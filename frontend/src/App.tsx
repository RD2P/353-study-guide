import { useState, useEffect } from 'react'
import { Routes, Route } from 'react-router-dom'
import './App.css'
import cachedTopics from './data/topics.json'
import cachedQuestions from './data/questions.json'
import AdminPage from './AdminPage'

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
  count: number
}

function shuffle<T>(arr: T[]): T[] {
  const a = [...arr]
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]]
  }
  return a
}

function QuizApp() {
  const [topics, setTopics] = useState<Topic[]>(cachedTopics as Topic[])
  const [selectedSlugs, setSelectedSlugs] = useState<Set<string>>(new Set())
  const [activeSlugs, setActiveSlugs] = useState<string[]>([])  // slugs used for current quiz
  const [phase, setPhase] = useState<'lobby' | 'quiz'>('lobby')

  const [questions, setQuestions] = useState<Question[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [currentIndex, setCurrentIndex] = useState(0)
  const [selected, setSelected] = useState<string | null>(null)
  const [score, setScore] = useState(0)
  const [skipped, setSkipped] = useState(0)
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

  function toggleTopic(slug: string) {
    setSelectedSlugs(prev => {
      const next = new Set(prev)
      next.has(slug) ? next.delete(slug) : next.add(slug)
      return next
    })
  }

  function startQuiz(slugs: string[]) {
    setActiveSlugs(slugs)
    setError(null)
    setCurrentIndex(0)
    setSelected(null)
    setScore(0)
    setSkipped(0)
    setFinished(false)

    // Show cached questions immediately so the quiz starts with no delay
    const cached = (cachedQuestions as Question[]).filter(q =>
      slugs.length === 0 || q.topics.some(t => slugs.includes(t))
    )
    if (cached.length > 0) {
      setQuestions(shuffle(cached))
      setLoading(false)
      setPhase('quiz')
    } else {
      setLoading(true)
    }

    // Fetch fresh data from backend silently; replace cache when it responds
    const url = slugs.length
      ? `${API_URL}/questions?topics=${slugs.join(',')}`
      : `${API_URL}/questions`

    fetch(url)
      .then(res => {
        if (!res.ok) throw new Error(`Server error: ${res.status}`)
        return res.json()
      })
      .then((data: Question[]) => {
        // Only replace if cache had nothing, avoids reshuffling mid-quiz
        if (cached.length === 0) {
          setQuestions(shuffle(data))
          setLoading(false)
          setPhase('quiz')
        }
      })
      .catch(err => {
        // Only surface the error if we have nothing to show
        if (cached.length === 0) {
          setError(err.message)
          setLoading(false)
        }
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

  function handleSkip() {
    setSkipped(s => s + 1)
    if (currentIndex + 1 >= total) {
      setFinished(true)
    } else {
      setCurrentIndex(i => i + 1)
      setSelected(null)
    }
  }

  function handleRestart() {
    startQuiz(activeSlugs)
  }

  function handleChangeTopic() {
    setSelectedSlugs(new Set(activeSlugs))
    setPhase('lobby')
    setFinished(false)
  }

  function handleStopQuiz() {
    if (window.confirm(`Stop the quiz? Your progress (${score}/${currentIndex + (selected !== null ? 1 : 0)}) will be lost.`)) {
      handleChangeTopic()
    }
  }

  const header = (
    <header className="site-header">
      <h1 className="site-title">CMPT 353 Winter 2026</h1>
      <p className="site-subtitle">Study Guide</p>
    </header>
  )

  if (loading) {
    const label = activeSlugs.length
      ? topics.filter(t => activeSlugs.includes(t.slug)).map(t => t.name).join(', ')
      : 'All Topics'
    return (
      <div className="page-wrapper">
        {header}
        <div className="quiz-container">
          <p className="status-msg">Loading questions for <strong>{label}</strong>...</p>
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
    const allSelected = selectedSlugs.size === 0
    const startLabel = selectedSlugs.size === 0
      ? 'Start Quiz — All Topics'
      : `Start Quiz — ${selectedSlugs.size} topic${selectedSlugs.size > 1 ? 's' : ''}`
    return (
      <div className="page-wrapper">
        {header}
        <div className="quiz-container">
          <h2 className="section-title">Choose Topics</h2>
          <p className="lobby-hint">
            {allSelected ? 'All topics selected.' : `${selectedSlugs.size} topic${selectedSlugs.size > 1 ? 's' : ''} selected`}
          </p>
          <div className="topic-grid">
            {topics.map(t => (
              <button
                key={t.slug}
                className={`topic-btn${selectedSlugs.has(t.slug) ? ' topic-btn--active' : ''}${t.count === 0 ? ' topic-btn--empty' : ''}`}
                onClick={() => toggleTopic(t.slug)}
                disabled={t.count === 0}
              >
                <span className="topic-btn-name">
                  {selectedSlugs.has(t.slug) && <span className="topic-check">✓</span>}
                  {t.name}
                </span>
                <span className="topic-count">{t.count} Qs</span>
              </button>
            ))}
          </div>
          <div className="lobby-actions">
            {selectedSlugs.size > 0 && (
              <button className="next-btn next-btn--secondary" onClick={() => setSelectedSlugs(new Set())}>
                Clear
              </button>
            )}
            <button className="next-btn" onClick={() => startQuiz([...selectedSlugs])}>
              {startLabel}
            </button>
          </div>
          <div className="contributor-invite">
            <p>
              Want to add or improve questions? <br/> <span className="discord-handle">DM me on Discord</span> and I&rsquo;ll give you access to the question editor.
            </p>
          </div>
        </div>
      </div>
    )
  }

  if (finished) {
    const pct = Math.round((score / total) * 100)
    const activeTopicNames = activeSlugs.length
      ? topics.filter(t => activeSlugs.includes(t.slug)).map(t => t.name).join(', ')
      : null
    return (
      <div className="page-wrapper">
        {header}
        <div className="quiz-container">
          <h2 className="section-title">Quiz Complete!</h2>
          {activeTopicNames && <p className="topic-badge">{activeTopicNames}</p>}
          <p className="final-score">You scored <strong>{score}</strong> out of <strong>{total}</strong></p>
          {skipped > 0 && <p className="skipped-count">{skipped} question{skipped > 1 ? 's' : ''} skipped</p>}
          <p className="score-pct">{pct}%</p>
          <div className="result-actions">
            <button className="next-btn" onClick={handleRestart}>Retry</button>
            <button className="next-btn next-btn--secondary" onClick={handleChangeTopic}>Change Topics</button>
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
          {activeSlugs.length > 0 && (
            <span className="topic-badge">
              {activeSlugs.length === 1
                ? topics.find(t => t.slug === activeSlugs[0])?.name
                : `${activeSlugs.length} topics`}
            </span>
          )}
          <button className="stop-btn" onClick={handleStopQuiz} title="Stop quiz">
            ✕ Stop
          </button>
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
        {selected === null && (
          <button className="skip-btn" onClick={handleSkip}>
            {currentIndex + 1 >= total ? 'Skip & See Results' : 'Skip Question'}
          </button>
        )}
        {selected !== null && (
          <button className="next-btn" onClick={handleNext}>
            {currentIndex + 1 >= total ? 'See Results' : 'Next Question'}
          </button>
        )}
      </div>
    </div>
  )
}

function App() {
  return (
    <Routes>
      <Route path="/" element={<QuizApp />} />
      <Route path="/admin" element={<AdminPage />} />
    </Routes>
  )
}

export default App
