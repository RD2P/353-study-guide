'use strict'

const express = require("express")
const cors = require("cors")
const { Pool } = require("pg")

const HOST = '0.0.0.0'
const PORT = 3000

const pool = new Pool({ connectionString: process.env.DATABASE_URL })

const app = express()
app.use(cors({
  origin: 'https://353-study-guide.vercel.app/'
}))
app.use(express.json())

app.get('/', (req,res)=> res.send("server ok..."))

pool.query('SELECT 1')
  .then(() => {
    console.log('DB connected')
    app.listen(PORT, HOST, () => console.log('Listening...'))
  })
  .catch(err => { console.error('Failed to connect to DB:', err); process.exit(1) })