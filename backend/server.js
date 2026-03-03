'use strict'

const express = require("express")
const cors = require("cors")

const HOST = '0.0.0.0'
const PORT = 3000

const app = express()
app.use(cors())
app.use(express.json())

app.get('/', (req,res)=> res.send("server ok..."))


app.listen(PORT, HOST, () => console.log('Listening...'))