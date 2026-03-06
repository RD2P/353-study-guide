'use strict'

const { Pool } = require('pg')

const pool = new Pool({ connectionString: process.env.DATABASE_URL })

const questions = [
  {
    question: "Which component of full stack development includes UI, layout, and user interaction?",
    options: ["Back-end technologies", "Database technologies", "Front-end technologies", "Deployment and hosting"],
    correctAnswer: "Front-end technologies"
  },
  {
    question: "Which of the following is a front-end framework?",
    options: ["Django", "Express.js", "React", "Flask"],
    correctAnswer: "React"
  },
  {
    question: "Which component handles data storage, processing, and retrieval?",
    options: ["Front-end technologies", "Back-end technologies", "Deployment tools", "WebAssembly"],
    correctAnswer: "Back-end technologies"
  },
  {
    question: "Which of the following is a back-end programming language?",
    options: ["HTML", "CSS", "Python", "Vue.js"],
    correctAnswer: "Python"
  },
  {
    question: "Which of the following is a back-end framework?",
    options: ["Angular", "Django", "MongoDB", "Kubernetes"],
    correctAnswer: "Django"
  },
  {
    question: "Which technology is used to store and retrieve application data?",
    options: ["Database technologies", "Front-end frameworks", "Hypervisors", "WebAssembly"],
    correctAnswer: "Database technologies"
  },
  {
    question: "Which of the following is a database management system (DBMS)?",
    options: ["React", "MySQL", "Express.js", "Docker"],
    correctAnswer: "MySQL"
  },
  {
    question: "What does CRUD stand for?",
    options: ["Create, Run, Update, Deploy", "Create, Read, Update, Delete", "Connect, Retrieve, Upload, Download", "Compile, Render, Upload, Delete"],
    correctAnswer: "Create, Read, Update, Delete"
  },
  {
    question: "Which HTTP method is typically used for retrieving data?",
    options: ["POST", "GET", "PUT", "DELETE"],
    correctAnswer: "GET"
  },
  {
    question: "Which HTTP method is typically associated with creating new resources?",
    options: ["GET", "DELETE", "POST", "PATCH"],
    correctAnswer: "POST"
  },
  {
    question: "What is stateless communication?",
    options: ["The server stores client session state permanently", "Each request is independent and based on current state", "Clients never send requests to servers", "The server cannot respond to requests"],
    correctAnswer: "Each request is independent and based on current state"
  },
  {
    question: "What is the role of a hypervisor?",
    options: ["Manages front-end frameworks", "Allows multiple virtual machines to run on one physical machine", "Stores application data", "Deploys containers to the cloud"],
    correctAnswer: "Allows multiple virtual machines to run on one physical machine"
  },
  {
    question: "Which statement best describes a virtual machine?",
    options: ["A lightweight package sharing the host OS kernel", "A software emulation of a physical machine with its own OS", "A database management system", "A client-side scripting environment"],
    correctAnswer: "A software emulation of a physical machine with its own OS"
  },
  {
    question: "Which statement best describes a container?",
    options: ["Runs a full separate OS on a hypervisor", "Provides total isolation with high resource cost", "Lightweight package including everything needed to run an application", "Only used for database management"],
    correctAnswer: "Lightweight package including everything needed to run an application"
  },
  {
    question: "Which tools are commonly used for deployment and orchestration?",
    options: ["HTML and CSS", "Docker and Kubernetes", "React and Vue.js", "MySQL and PostgreSQL"],
    correctAnswer: "Docker and Kubernetes"
  }
]

async function seed() {
  const client = await pool.connect()
  try {
    await client.query('BEGIN')

    for (const q of questions) {
      const { rows } = await client.query(
        'INSERT INTO questions (question_text) VALUES ($1) RETURNING id',
        [q.question]
      )
      const questionId = rows[0].id

      for (const optionText of q.options) {
        await client.query(
          'INSERT INTO options (question_id, option_text, is_correct) VALUES ($1, $2, $3)',
          [questionId, optionText, optionText === q.correctAnswer]
        )
      }
    }

    await client.query('COMMIT')
    console.log(`Seeded ${questions.length} questions successfully.`)
  } catch (err) {
    await client.query('ROLLBACK')
    console.error('Seed failed, rolled back:', err.message)
    process.exit(1)
  } finally {
    client.release()
    await pool.end()
  }
}

seed()
