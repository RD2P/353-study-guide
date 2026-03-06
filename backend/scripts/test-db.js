'use strict'

const { Pool } = require('pg')

const connectionString = process.env.DATABASE_URL

const pool = new Pool({
  connectionString,
  ssl: { rejectUnauthorized: false }
})

async function test() {
  try {
    const result = await pool.query('SELECT * FROM questions')
    console.log(`Connected! Found ${result.rows.length} questions:\n`)
    result.rows.forEach(row => console.log(`[${row.id}] ${row.question_text}`))
  } catch (err) {
    console.error('Connection failed:', err.message)
    process.exit(1)
  } finally {
    await pool.end()
  }
}

test()
