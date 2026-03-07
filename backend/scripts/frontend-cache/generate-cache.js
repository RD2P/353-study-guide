'use strict'

/**
 * generate-cache.js
 *
 * Queries the DB directly and writes topics.json + questions.json.
 * Run from the backend/ directory:
 *
 *   node scripts/frontend-cache/generate-cache.js
 *
 * Then copy the output files to frontend/src/data/
 *
 *   cp scripts/frontend-cache/out/*.json ../frontend/src/data/
 */

const fs = require('fs')
const path = require('path')
const { Pool } = require('pg')

const pool = new Pool({
  connectionString: process.env.DATABASE_URL_LOCAL ?? process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'PROD' ? { rejectUnauthorized: false } : false,
})

const OUT_DIR = path.join(__dirname, 'out')

async function fetchTopics() {
  const { rows } = await pool.query(`
    SELECT t.slug, t.name, COUNT(qt.question_id)::int AS count
    FROM topics t
    LEFT JOIN question_topics qt ON qt.topic_id = t.id
    GROUP BY t.id
    ORDER BY t.name
  `)
  return rows
}

async function fetchQuestions() {
  const { rows } = await pool.query(`
    SELECT
      q.id,
      q.question_text AS question,
      (
        SELECT json_agg(o.option_text ORDER BY o.id)
        FROM options o
        WHERE o.question_id = q.id
      ) AS options,
      (
        SELECT o.option_text
        FROM options o
        WHERE o.question_id = q.id AND o.is_correct
        LIMIT 1
      ) AS "correctAnswer",
      COALESCE(
        (
          SELECT json_agg(t.slug)
          FROM question_topics qt
          JOIN topics t ON t.id = qt.topic_id
          WHERE qt.question_id = q.id
        ),
        '[]'::json
      ) AS topics
    FROM questions q
    ORDER BY q.id
  `)
  return rows
}

async function main() {
  console.log('Connecting to DB…')

  const [topics, questions] = await Promise.all([fetchTopics(), fetchQuestions()])

  fs.mkdirSync(OUT_DIR, { recursive: true })

  fs.writeFileSync(
    path.join(OUT_DIR, 'topics.json'),
    JSON.stringify(topics, null, 2) + '\n'
  )
  fs.writeFileSync(
    path.join(OUT_DIR, 'questions.json'),
    JSON.stringify(questions, null, 2) + '\n'
  )

  console.log(`✓ ${topics.length} topics    → scripts/frontend-cache/out/topics.json`)
  console.log(`✓ ${questions.length} questions → scripts/frontend-cache/out/questions.json`)
  console.log('\nCopy to frontend:')
  console.log('  cp scripts/frontend-cache/out/*.json ../frontend/src/data/')
}

main()
  .catch(err => {
    console.error('✗', err.message)
    process.exit(1)
  })
  .finally(() => pool.end())
