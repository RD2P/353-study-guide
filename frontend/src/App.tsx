import { useState } from 'react'
import questions from '../question-bank.json'
import './App.css'

type Question = {
  question: string
  options: string[]
  correctAnswer: string
}

function App() {
  const [currentIndex, setCurrentIndex] = useState(0)
  const [selected, setSelected] = useState<string | null>(null)
  const [score, setScore] = useState(0)
  const [finished, setFinished] = useState(false)

  const q: Question = (questions as Question[])[currentIndex]
  const total = (questions as Question[]).length

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

  if (finished) {
    return (
      <div className="quiz-container">
        <h1>Quiz Complete!</h1>
        <p className="final-score">You scored <strong>{score}</strong> out of <strong>{total}</strong></p>
        <p className="score-pct">{Math.round((score / total) * 100)}%</p>
        <button className="next-btn" onClick={handleRestart}>Restart Quiz</button>
      </div>
    )
  }

  return (
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
  )
}

export default App
