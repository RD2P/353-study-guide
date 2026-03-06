import { useState, useEffect } from 'react'
import './App.css'

const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:81'

type Question = {
  question: string
  options: string[]
  correctAnswer: string
}

function App() {
  const [questions, setQuestions] = useState<Question[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [currentIndex, setCurrentIndex] = useState(0)
  const [selected, setSelected] = useState<string | null>(null)
  const [score, setScore] = useState(0)
  const [finished, setFinished] = useState(false)

  useEffect(() => {
    fetch(`${API_URL}/questions`)
      .then(res => {
        if (!res.ok) throw new Error(`Server error: ${res.status}`)
        return res.json()
      })
      .then((data: Question[]) => {
        setQuestions(data)
        setLoading(false)
      })
      .catch(err => {
        setError(err.message)
        setLoading(false)
      })
  }, [])

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
    setCurrentIndex(0)
    setSelected(null)
    setScore(0)
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
        <div className="quiz-container"><p className="status-msg">Loading questions...</p></div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="page-wrapper">
        {header}
        <div className="quiz-container"><p className="status-msg error-msg">Error: {error}</p></div>
      </div>
    )
  }

  if (finished) {
    return (
      <div className="page-wrapper">
        {header}
        <div className="quiz-container">
          <h2 className="section-title">Quiz Complete!</h2>
          <p className="final-score">You scored <strong>{score}</strong> out of <strong>{total}</strong></p>
          <p className="score-pct">{Math.round((score / total) * 100)}%</p>
          <button className="next-btn" onClick={handleRestart}>Restart Quiz</button>
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
