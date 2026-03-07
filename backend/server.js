'use strict'

const express = require("express")
const cors = require("cors")
const { Pool } = require("pg")

const HOST = '0.0.0.0'
const PORT = 3000

const connectionString = process.env.DATABASE_URL

const pool = new Pool({
  connectionString,
  ssl: process.env.NODE_ENV === 'PROD' ? { rejectUnauthorized: false } : false
})

const app = express()
app.use(cors())
app.use(express.json())

app.get('/', (req,res)=> res.send("server ok..."))

// GET /topics  – list all available topics with question counts
app.get('/topics', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT t.slug, t.name, COUNT(qt.question_id)::int AS count
      FROM topics t
      LEFT JOIN question_topics qt ON qt.topic_id = t.id
      GROUP BY t.id
      ORDER BY t.name
    `)
    res.json(result.rows)
  } catch (err) {
    console.error('Error fetching topics:', err)
    res.status(500).json({ error: 'Failed to fetch topics' })
  }
})

// GET /questions?topics=slug1,slug2  – optional comma-separated topic filter
app.get('/questions', async (req, res) => {
  const raw = req.query.topics

  // Parse and validate slugs
  const slugs = raw
    ? String(raw).split(',').map(s => s.trim()).filter(Boolean)
    : []

  if (slugs.some(s => !/^[a-z0-9_-]+$/.test(s))) {
    return res.status(400).json({ error: 'Invalid topic slug' })
  }

  try {
    const result = await pool.query(`
      SELECT
        q.id,
        q.question_text                                     AS question,
        COALESCE(
          (
            SELECT json_agg(o.option_text ORDER BY o.id)
            FROM options o
            WHERE o.question_id = q.id
          ),
          '[]'::json
        )                                                   AS options,
        (
          SELECT o.option_text
          FROM options o
          WHERE o.question_id = q.id AND o.is_correct
          LIMIT 1
        )                                                   AS "correctAnswer",
        COALESCE(
          (
            SELECT json_agg(t.slug)
            FROM question_topics qt
            JOIN topics t ON t.id = qt.topic_id
            WHERE qt.question_id = q.id
          ),
          '[]'::json
        )                                                   AS topics
      FROM questions q
      WHERE ($1::text[] IS NULL OR EXISTS (
        SELECT 1
        FROM question_topics qt2
        JOIN topics t2 ON t2.id = qt2.topic_id
        WHERE qt2.question_id = q.id
          AND t2.slug = ANY($1::text[])
      ))
      ORDER BY q.id
    `, [slugs.length ? slugs : null])
    res.json(result.rows)
  } catch (err) {
    console.error('Error fetching questions:', err)
    res.status(500).json({ error: 'Failed to fetch questions' })
  }
})

// ── Admin middleware ──────────────────────────────────────────────────────────
function requireAdmin(req, res, next) {
  const key = req.headers['x-admin-key']
  if (!process.env.ADMIN_KEY || key !== process.env.ADMIN_KEY) {
    return res.status(401).json({ error: 'Unauthorized' })
  }
  next()
}

// Helper: fetch a question by id in the same shape as GET /questions
async function fetchQuestion(id) {
  const { rows } = await pool.query(`
    SELECT
      q.id,
      q.question_text AS question,
      COALESCE(
        (SELECT json_agg(o.option_text ORDER BY o.id)
        FROM options o WHERE o.question_id = q.id),
        '[]'::json
      ) AS options,
      (
        SELECT o.option_text FROM options o
        WHERE o.question_id = q.id AND o.is_correct LIMIT 1
      ) AS "correctAnswer",
      COALESCE(
        (SELECT json_agg(t.slug) FROM question_topics qt
         JOIN topics t ON t.id = qt.topic_id
         WHERE qt.question_id = q.id),
        '[]'::json
      ) AS topics
    FROM questions q WHERE q.id = $1
  `, [id])
  return rows[0] ?? null
}

// POST /questions — create a new question with options and topics
app.post('/questions', requireAdmin, async (req, res) => {
  const { question, options, correctAnswer, topics: topicSlugs = [] } = req.body
  if (!question || !Array.isArray(options) || options.length === 0 || !correctAnswer) {
    return res.status(400).json({ error: 'question, options, and correctAnswer are required' })
  }

  const client = await pool.connect()
  try {
    await client.query('BEGIN')

    const { rows: [{ id }] } = await client.query(
      'INSERT INTO questions (question_text) VALUES ($1) RETURNING id',
      [question]
    )

    for (const opt of options) {
      await client.query(
        'INSERT INTO options (question_id, option_text, is_correct) VALUES ($1, $2, $3)',
        [id, opt, opt === correctAnswer]
      )
    }

    if (topicSlugs.length > 0) {
      const { rows: topicRows } = await client.query(
        'SELECT id, slug FROM topics WHERE slug = ANY($1)',
        [topicSlugs]
      )
      for (const { id: topicId } of topicRows) {
        await client.query(
          'INSERT INTO question_topics (question_id, topic_id) VALUES ($1, $2)',
          [id, topicId]
        )
      }
    }

    await client.query('COMMIT')
    res.status(201).json(await fetchQuestion(id))
  } catch (err) {
    await client.query('ROLLBACK')
    console.error('Error creating question:', err)
    res.status(500).json({ error: 'Failed to create question' })
  } finally {
    client.release()
  }
})

// PUT /questions/:id — replace a question's text, options, and topics
app.put('/questions/:id', requireAdmin, async (req, res) => {
  const id = parseInt(req.params.id, 10)
  const { question, options, correctAnswer, topics: topicSlugs = [] } = req.body
  if (!question || !Array.isArray(options) || options.length === 0 || !correctAnswer) {
    return res.status(400).json({ error: 'question, options, and correctAnswer are required' })
  }

  const client = await pool.connect()
  try {
    await client.query('BEGIN')

    await client.query('UPDATE questions SET question_text = $1 WHERE id = $2', [question, id])

    // Replace options and topics wholesale — simplest correct approach
    await client.query('DELETE FROM options WHERE question_id = $1', [id])
    for (const opt of options) {
      await client.query(
        'INSERT INTO options (question_id, option_text, is_correct) VALUES ($1, $2, $3)',
        [id, opt, opt === correctAnswer]
      )
    }

    await client.query('DELETE FROM question_topics WHERE question_id = $1', [id])
    if (topicSlugs.length > 0) {
      const { rows: topicRows } = await client.query(
        'SELECT id FROM topics WHERE slug = ANY($1)',
        [topicSlugs]
      )
      for (const { id: topicId } of topicRows) {
        await client.query(
          'INSERT INTO question_topics (question_id, topic_id) VALUES ($1, $2)',
          [id, topicId]
        )
      }
    }

    await client.query('COMMIT')
    const updated = await fetchQuestion(id)
    if (!updated) return res.status(404).json({ error: 'Question not found' })
    res.json(updated)
  } catch (err) {
    await client.query('ROLLBACK')
    console.error('Error updating question:', err)
    res.status(500).json({ error: 'Failed to update question' })
  } finally {
    client.release()
  }
})

// DELETE /questions/:id — delete a question (options and question_topics cascade)
app.delete('/questions/:id', requireAdmin, async (req, res) => {
  const id = parseInt(req.params.id, 10)
  try {
    const { rowCount } = await pool.query('DELETE FROM questions WHERE id = $1', [id])
    if (rowCount === 0) return res.status(404).json({ error: 'Question not found' })
    res.status(204).end()
  } catch (err) {
    console.error('Error deleting question:', err)
    res.status(500).json({ error: 'Failed to delete question' })
  }
})

pool.query('SELECT 1')
  .then(() => {
    console.log('DB connected')
    app.listen(PORT, HOST, () => console.log('Listening...'))
  })
  .catch(err => { console.error('Failed to connect to DB:', err); process.exit(1) })