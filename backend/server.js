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
        (
          SELECT json_agg(o.option_text ORDER BY o.id)
          FROM options o
          WHERE o.question_id = q.id
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

pool.query('SELECT 1')
  .then(() => {
    console.log('DB connected')
    app.listen(PORT, HOST, () => console.log('Listening...'))
  })
  .catch(err => { console.error('Failed to connect to DB:', err); process.exit(1) })