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

app.get('/questions', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        q.id,
        q.question_text AS question,
        json_agg(o.option_text ORDER BY o.id) AS options,
        MAX(CASE WHEN o.is_correct THEN o.option_text END) AS "correctAnswer"
      FROM questions q
      JOIN options o ON o.question_id = q.id
      GROUP BY q.id
      ORDER BY q.id
    `)
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