'use strict'

const express = require("express")
const cors = require("cors")
const { Pool } = require("pg")

const HOST = '0.0.0.0'
const PORT = 3000

const pool = new Pool({ connectionString: process.env.DATABASE_URL })

async function initDB() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS questions (
      id        SERIAL PRIMARY KEY,
      text      TEXT NOT NULL,
      topic_id  INTEGER
    )
  `)
  console.log('DB ready')
}

const app = express()
app.use(cors())
app.use(express.json())

app.get('/', (req,res)=> res.send("server ok..."))

initDB()
  .then(() => app.listen(PORT, HOST, () => console.log('Listening...')))
  .catch(err => { console.error('Failed to init DB:', err); process.exit(1) })