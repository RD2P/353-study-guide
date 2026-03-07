import { useState, useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'

const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:81'
const ADMIN_KEY = import.meta.env.VITE_ADMIN_KEY ?? ''

type AdminQuestion = {
  id: number
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

const EMPTY_FORM = {
  question: '',
  options: ['', '', '', ''],
  correctAnswer: '',
  topics: [] as string[],
}

function adminFetch(path: string, options: RequestInit = {}) {
  return fetch(`${API_URL}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      'x-admin-key': ADMIN_KEY,
      ...options.headers,
    },
  })
}

function QuestionForm({
  initial,
  allTopics,
  onSave,
  onCancel,
  saveLabel,
}: {
  initial: typeof EMPTY_FORM
  allTopics: Topic[]
  onSave: (data: typeof EMPTY_FORM) => Promise<void>
  onCancel?: () => void
  saveLabel: string
}) {
  const [form, setForm] = useState(initial)
  const [saving, setSaving] = useState(false)
  const [err, setErr] = useState<string | null>(null)

  function setOption(i: number, val: string) {
    const opts = [...form.options]
    opts[i] = val
    // If the correct answer was this option's old value, clear it
    setForm(f => ({ ...f, options: opts, correctAnswer: f.correctAnswer === f.options[i] ? '' : f.correctAnswer }))
  }

  function toggleTopic(slug: string) {
    setForm(f => ({
      ...f,
      topics: f.topics.includes(slug) ? f.topics.filter(s => s !== slug) : [...f.topics, slug],
    }))
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (!form.question.trim()) return setErr('Question text is required')
    if (form.options.some(o => !o.trim())) return setErr('All four options are required')
    if (!form.correctAnswer) return setErr('Select the correct answer')
    setErr(null)
    setSaving(true)
    try {
      await onSave(form)
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : 'Save failed')
    } finally {
      setSaving(false)
    }
  }

  return (
    <form className="admin-form" onSubmit={handleSubmit}>
      <label className="admin-label">Question</label>
      <textarea
        className="admin-input admin-textarea"
        value={form.question}
        onChange={e => setForm(f => ({ ...f, question: e.target.value }))}
        rows={3}
        placeholder="Question text..."
      />

      <label className="admin-label">Options (select the correct one)</label>
      {form.options.map((opt, i) => (
        <div key={i} className="admin-option-row">
          <input
            type="radio"
            name="correct"
            checked={form.correctAnswer === opt && opt !== ''}
            onChange={() => setForm(f => ({ ...f, correctAnswer: f.options[i] }))}
            disabled={!opt.trim()}
            title="Mark as correct"
          />
          <input
            className="admin-input"
            value={opt}
            onChange={e => setOption(i, e.target.value)}
            placeholder={`Option ${i + 1}`}
          />
        </div>
      ))}

      <label className="admin-label">Topics</label>
      <div className="admin-topic-checks">
        {allTopics.map(t => (
          <label key={t.slug} className="admin-topic-check">
            <input
              type="checkbox"
              checked={form.topics.includes(t.slug)}
              onChange={() => toggleTopic(t.slug)}
            />
            {t.name}
          </label>
        ))}
      </div>

      {err && <p className="admin-err">{err}</p>}

      <div className="admin-form-actions">
        <button type="submit" className="admin-btn admin-btn--primary" disabled={saving}>
          {saving ? 'Saving…' : saveLabel}
        </button>
        {onCancel && (
          <button type="button" className="admin-btn admin-btn--secondary" onClick={onCancel}>
            Cancel
          </button>
        )}
      </div>
    </form>
  )
}

export default function AdminPage() {
  const [params] = useSearchParams()
  const key = params.get('key') ?? ''

  const [questions, setQuestions] = useState<AdminQuestion[]>([])
  const [topics, setTopics] = useState<Topic[]>([])
  const [loading, setLoading] = useState(true)
  const [err, setErr] = useState<string | null>(null)
  const [editingId, setEditingId] = useState<number | null>(null)
  const [showAddForm, setShowAddForm] = useState(false)
  const [search, setSearch] = useState('')

  const authorized = key === ADMIN_KEY && ADMIN_KEY !== ''

  useEffect(() => {
    if (!authorized) return
    Promise.all([
      fetch(`${API_URL}/questions`).then(r => r.json()),
      fetch(`${API_URL}/topics`).then(r => r.json()),
    ])
      .then(([qs, ts]) => { setQuestions(qs); setTopics(ts) })
      .catch(() => setErr('Failed to load data'))
      .finally(() => setLoading(false))
  }, [authorized])

  async function handleAdd(form: typeof EMPTY_FORM) {
    const res = await adminFetch('/questions', {
      method: 'POST',
      body: JSON.stringify(form),
    })
    if (!res.ok) throw new Error(await res.text())
    const created: AdminQuestion = await res.json()
    setQuestions(qs => [created, ...qs])
    setShowAddForm(false)
  }

  async function handleEdit(id: number, form: typeof EMPTY_FORM) {
    const res = await adminFetch(`/questions/${id}`, {
      method: 'PUT',
      body: JSON.stringify(form),
    })
    if (!res.ok) throw new Error(await res.text())
    const updated: AdminQuestion = await res.json()
    setQuestions(qs => qs.map(q => q.id === id ? updated : q))
    setEditingId(null)
  }

  async function handleDelete(id: number, questionText: string) {
    if (!window.confirm(`Delete this question?\n\n"${questionText}"`)) return
    const res = await adminFetch(`/questions/${id}`, { method: 'DELETE' })
    if (!res.ok) throw new Error(await res.text())
    setQuestions(qs => qs.filter(q => q.id !== id))
  }

  if (!authorized) {
    return (
      <div className="page-wrapper">
        <header className="site-header">
          <h1 className="site-title">Access Denied</h1>
        </header>
        <div className="quiz-container">
          <p className="status-msg">Invalid or missing admin key.</p>
        </div>
      </div>
    )
  }

  const filtered = questions.filter(q =>
    !search || q.question.toLowerCase().includes(search.toLowerCase())
  )

  return (
    <div className="page-wrapper">
      <header className="site-header">
        <h1 className="site-title">Admin</h1>
        <p className="site-subtitle">Question Management</p>
        <p className="admin-page-desc">Review, add, edit, and delete quiz questions.</p>
      </header>

      <div className="admin-container">
        {/* Add question */}
        {showAddForm ? (
          <div className="admin-card">
            <h2 className="admin-section-title">Add Question</h2>
            <QuestionForm
              initial={EMPTY_FORM}
              allTopics={topics}
              onSave={handleAdd}
              onCancel={() => setShowAddForm(false)}
              saveLabel="Add Question"
            />
          </div>
        ) : (
          <button className="admin-btn admin-btn--primary admin-add-btn" onClick={() => setShowAddForm(true)}>
            + Add Question
          </button>
        )}

        {/* Search */}
        <input
          className="admin-input admin-search"
          placeholder={`Search ${questions.length} questions…`}
          value={search}
          onChange={e => setSearch(e.target.value)}
        />

        {loading && <p className="status-msg">Loading… (may take up to 60s for backend service cold-start on first visit)</p>}
        {err && <p className="status-msg error-msg">{err}</p>}

        {/* Question list */}
        <div className="admin-question-list">
          {filtered.map(q => (
            <div key={q.id} className="admin-card">
              {editingId === q.id ? (
                <>
                  <h3 className="admin-section-title">Edit Question</h3>
                  <QuestionForm
                    initial={{ question: q.question, options: [...q.options], correctAnswer: q.correctAnswer, topics: [...q.topics] }}
                    allTopics={topics}
                    onSave={form => handleEdit(q.id, form)}
                    onCancel={() => setEditingId(null)}
                    saveLabel="Save Changes"
                  />
                </>
              ) : (
                <>
                  <div className="admin-q-header">
                    <span className="admin-q-id">#{q.id}</span>
                    <div className="admin-q-actions">
                      <button className="admin-btn admin-btn--secondary" onClick={() => setEditingId(q.id)}>Edit</button>
                      <button className="admin-btn admin-btn--danger" onClick={() => handleDelete(q.id, q.question)}>Delete</button>
                    </div>
                  </div>

                  <p className="admin-q-text">{q.question}</p>

                  <ul className="admin-options-list">
                    {q.options.map(opt => (
                      <li
                        key={opt}
                        className={`admin-option${opt === q.correctAnswer ? ' admin-option--correct' : ''}`}
                      >
                        {opt === q.correctAnswer && <span className="admin-correct-mark">✓ </span>}
                        {opt}
                      </li>
                    ))}
                  </ul>

                  {q.topics.length > 0 && (
                    <div className="admin-q-topics">
                      {q.topics.map(slug => (
                        <span key={slug} className="topic-badge">{slug}</span>
                      ))}
                    </div>
                  )}
                </>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
