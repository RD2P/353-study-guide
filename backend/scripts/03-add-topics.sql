-- ============================================================
-- Migration: add topic filtering
-- Safe to run on local Postgres and Supabase (idempotent).
-- ============================================================

-- 1. Topics lookup table
--    To add a new topic just INSERT a row here – no schema change needed.
CREATE TABLE IF NOT EXISTS topics (
    id   SERIAL PRIMARY KEY,
    slug TEXT NOT NULL UNIQUE,   -- used in API queries, e.g. 'react', 'sql'
    name TEXT NOT NULL           -- human-readable label
);

-- 2. Many-to-many join table
--    A question can belong to multiple topics; a topic covers many questions.
CREATE TABLE IF NOT EXISTS question_topics (
    question_id INTEGER NOT NULL
        REFERENCES questions(id) ON DELETE CASCADE,
    topic_id    INTEGER NOT NULL
        REFERENCES topics(id)    ON DELETE CASCADE,
    PRIMARY KEY (question_id, topic_id)
);

CREATE INDEX IF NOT EXISTS idx_qt_topic_id ON question_topics(topic_id);

-- ============================================================
-- 3. Seed known topics
--    ON CONFLICT DO NOTHING makes this re-runnable.
-- ============================================================
INSERT INTO topics (slug, name) VALUES
    ('containerization', 'Containerization'),
    ('http',             'HTTP'),
    ('rest',             'REST'),
    ('node',             'Node / Express'),
    ('html',             'HTML'),
    ('css',              'CSS'),
    ('js',               'JavaScript'),
    ('react',            'React'),
    ('next',             'Next.js'),
    ('sql',              'SQL'),
    ('cloud',            'Cloud')
ON CONFLICT (slug) DO NOTHING;

-- ============================================================
-- 4. Tag existing seed questions (by ID from 02-seed.sql)
--    ON CONFLICT DO NOTHING makes this re-runnable.
-- ============================================================
INSERT INTO question_topics (question_id, topic_id)
SELECT q.id, t.id FROM (VALUES
    -- Q1  – full-stack layers (what is front-end?)
    (1,  'html'),
    (1,  'css'),
    -- Q2  – which is a front-end framework?
    (2,  'react'),
    -- Q3  – full-stack: back-end role
    (3,  'node'),
    -- Q4  – back-end language
    (4,  'node'),
    -- Q5  – back-end framework
    (5,  'node'),
    -- Q6  – what stores application data?
    (6,  'sql'),
    -- Q7  – which is a DBMS?
    (7,  'sql'),
    -- Q8  – what does CRUD stand for?
    (8,  'rest'),
    (8,  'sql'),
    -- Q9  – GET method
    (9,  'http'),
    (9,  'rest'),
    -- Q10 – POST method
    (10, 'http'),
    (10, 'rest'),
    -- Q11 – stateless communication
    (11, 'http'),
    (11, 'rest'),
    -- Q12 – hypervisor
    (12, 'containerization'),
    -- Q13 – virtual machine
    (13, 'containerization'),
    -- Q14 – container definition
    (14, 'containerization'),
    -- Q15 – Docker / Kubernetes
    (15, 'containerization'),
    (15, 'cloud')
) AS mapping(qid, slug)
JOIN questions q ON q.id = mapping.qid
JOIN topics    t ON t.slug = mapping.slug
ON CONFLICT DO NOTHING;
