import { useState, useEffect } from 'react'
import './App.css'

const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:81'

type Question = {
  question: string
  options: string[]
  correctAnswer: string
  topics: string[]
}

type Topic = {
  slug: string
  name: string
}

function App() {
  const [topics, setTopics] = useState<Topic[]>([])
  const [activeTopic, setActiveTopic] = useState<Topic | null>(null)
  const [phase, setPhase] = useState<'lobby' | 'quiz'>('lobby')

  const [questions, setQuestions] = useState<Question[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [currentIndex, setCurrentIndex] = useState(0)
  const [selected, setSelected] = useState<string | null>(null)
  const [score, setScore] = useState(0)
  const [finished, setFinished] = useState(false)

  // Fetch topic list once on mount
  useEffect(() => {
    fetch(`${API_URL}/topics`)
      .then(res => {
        if (!res.ok) throw new Error(`Server error: ${res.status}`)
        return res.json()
      })
      .then((data: Topic[]) => setTopics(data))
      .catch(() => { /* topics list is non-fatal */ })
  }, [])

  function startQuiz(topic: Topic | null) {
    setActiveTopic(topic)
    setLoading(true)
    setError(null)
    setCurrentIndex(0)
    setSelected(null)
    setScore(0)
    setFinished(false)

    const url = topic
      ? `${API_URL}/questions?topic=${topic.slug}`
      : `${API_URL}/questions`

    fetch(url)
      .then(res => {
        if (!res.ok) throw new Error(`Server error: ${res.status}`)
        return res.json()
      })
      .then((data: Question[]) => {
        setQuestions(data)
        setLoading(false)
        setPhase('quiz')
      })
      .catch(err => {
        setError(err.message)
        setLoading(false)
      })
  }

  const q: Question = questions[currentIndex]
  const total = questions.length

  function handleSelect(option: string) {
    if (selected !== null) return
    setSelected(option)
    if (option === q.correctAnswer) {
      setScore(s => s + 1)
    }
  }

  function handleNext() {
    if (currentIndex + 1 >= total) {
      setFinished(true)
    } else {
      setCurrentIndex(i => i + 1)
      setSelected(null)
    }
  }

  function handleRestart() {
    startQuiz(activeTopic)
  }

  function handleChangeTopic() {
    setPhase('lobby')
    setFinished(false)
  }

  const header = (
    <header className="site-header">
      <h1 className="site-title">CMPT 353 Winter 2026</h1>
      <p className="site-subtitle">Study Guide</p>
    </header>
  )

  if (loading) {
    return (
      <div className="page-wrapper">
        {header}
        <div className="quiz-container">
          <p className="status-msg">Loading questions{activeTopic ? ` for ${activeTopic.name}` : ''}...</p>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="page-wrapper">
        {header}
        <div className="quiz-container">
          <p className="status-msg error-msg">Error: {error}</p>
          <button className="next-btn" onClick={handleChangeTopic}>Back to Topics</button>
        </div>
      </div>
    )
  }

  if (phase === 'lobby') {
    return (
      <div className="page-wrapper">
        {header}
        <div className="quiz-container">
          <h2 className="section-title">Choose a Topic</h2>
          <div className="topic-grid">
            <button className="topic-btn topic-btn--all" onClick={() => startQuiz(null)}>
              All Topics
            </button>
            {topics.map(t => (
              <button key={t.slug} className="topic-btn" onClick={() => startQuiz(t)}>
                {t.name}
              </button>
            ))}
          </div>
        </div>
      </div>
    )
  }

  if (finished) {
    const pct = Math.round((score / total) * 100)
    return (
      <div className="page-wrapper">
        {header}
        <div className="quiz-container">
          <h2 className="section-title">Quiz Complete!</h2>
          {activeTopic && <p className="topic-badge">{activeTopic.name}</p>}
          <p className="final-score">You scored <strong>{score}</strong> out of <strong>{total}</strong></p>
          <p className="score-pct">{pct}%</p>
          <div className="result-actions">
            <button className="next-btn" onClick={handleRestart}>Retry</button>
            <button className="next-btn next-btn--secondary" onClick={handleChangeTopic}>Change Topic</button>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="page-wrapper">
      {header}
      <div className="quiz-container">
        <div className="quiz-header">
          <span className="progress">Question {currentIndex + 1} / {total}</span>
          <span className="score">Score: {score}</span>
          {activeTopic && <span className="topic-badge">{activeTopic.name}</span>}
        </div>
        <div className="question-card">
          <p className="question-text">{q.question}</p>
          <div className="options">
            {q.options.map(option => {
              let cls = 'option-btn'
              if (selected !== null) {
                if (option === q.correctAnswer) cls += ' correct'
                else if (option === selected) cls += ' wrong'
                else cls += ' dimmed'
              }
              return (
                <button
                  key={option}
                  className={cls}
                  onClick={() => handleSelect(option)}
                >
                  {option}
                </button>
              )
            })}
          </div>
          {selected !== null && (
            <div className="feedback">
              {selected === q.correctAnswer
                ? <span className="feedback-correct">Correct!</span>
                : <span className="feedback-wrong">Wrong — the answer is "{q.correctAnswer}"</span>
              }
            </div>
          )}
        </div>
        {selected !== null && (
          <button className="next-btn" onClick={handleNext}>
            {currentIndex + 1 >= total ? 'See Results' : 'Next Question'}
          </button>
        )}
      </div>
    </div>
  )
}

export default App
