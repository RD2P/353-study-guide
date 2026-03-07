-- ============================================================
-- Seed: REST / MCP / NoSQL / LLM / Express questions (10 questions)
-- Requires: 01-init.sql, 03-add-topics.sql already applied.
-- Wrapped in a transaction so it either fully succeeds or rolls back.
-- ============================================================

BEGIN;

WITH new_questions AS (
  INSERT INTO questions (question_text) VALUES
    ('In the Richardson Maturity Model, what distinguishes a Level 1 API from a Level 0 API?'),
    ('Which REST constraint is most directly addressed by Richardson Maturity Level 3 (HATEOAS)?'),
    ('When running local LLMs with Ollama, what is the primary purpose of Quantization in model files?'),
    ('In the Model Context Protocol (MCP), which entity is responsible for actually executing a tool?'),
    ('Which concept describes how CouchDB handles concurrent updates without traditional table-level locks?'),
    ('According to the CAP Theorem, which two properties does CouchDB prioritize during a network partition?'),
    ('In Express.js middleware, what happens if a function does not call next() and does not send a response?'),
    ('Which security risk is associated with autonomous agents like OpenClaw?'),
    ('What is the specific role of the cors middleware package in a Node/Express application?'),
    ('In local LLMs like DeepSeek-R1, what is the function of Chain of Thought (CoT) inside <think> tags?')
  RETURNING id, question_text
),

new_options AS (
  INSERT INTO options (question_id, option_text, is_correct)
  SELECT nq.id, v.opt, v.correct
  FROM new_questions nq
  JOIN (VALUES
    -- Q1: RMM Level 1 vs Level 0
    ('In the Richardson Maturity Model, what distinguishes a Level 1 API from a Level 0 API?', 'The use of HTTP verbs like GET and DELETE',                          false),
    ('In the Richardson Maturity Model, what distinguishes a Level 1 API from a Level 0 API?', 'The introduction of HATEOAS and hypermedia links',                   false),
    ('In the Richardson Maturity Model, what distinguishes a Level 1 API from a Level 0 API?', 'The use of individual Resource URIs instead of a single endpoint',   true),
    ('In the Richardson Maturity Model, what distinguishes a Level 1 API from a Level 0 API?', 'The implementation of semantic HTTP status codes',                    false),
    -- Q2: HATEOAS REST constraint
    ('Which REST constraint is most directly addressed by Richardson Maturity Level 3 (HATEOAS)?', 'Statelessness',      false),
    ('Which REST constraint is most directly addressed by Richardson Maturity Level 3 (HATEOAS)?', 'Uniform Interface',  true),
    ('Which REST constraint is most directly addressed by Richardson Maturity Level 3 (HATEOAS)?', 'Layered System',     false),
    ('Which REST constraint is most directly addressed by Richardson Maturity Level 3 (HATEOAS)?', 'Cacheability',       false),
    -- Q3: Quantization
    ('When running local LLMs with Ollama, what is the primary purpose of Quantization in model files?', 'To increase the creative randomness of the model''s output',              false),
    ('When running local LLMs with Ollama, what is the primary purpose of Quantization in model files?', 'To reduce the model''s memory footprint so it fits on consumer GPUs',     true),
    ('When running local LLMs with Ollama, what is the primary purpose of Quantization in model files?', 'To encrypt the model for secure local storage',                           false),
    ('When running local LLMs with Ollama, what is the primary purpose of Quantization in model files?', 'To allow the model to process multiple languages simultaneously',         false),
    -- Q4: MCP tool executor
    ('In the Model Context Protocol (MCP), which entity is responsible for actually executing a tool?', 'The LLM (Large Language Model)',   false),
    ('In the Model Context Protocol (MCP), which entity is responsible for actually executing a tool?', 'The MCP Client/Orchestrator',      true),
    ('In the Model Context Protocol (MCP), which entity is responsible for actually executing a tool?', 'The System Prompt',                false),
    ('In the Model Context Protocol (MCP), which entity is responsible for actually executing a tool?', 'The JSON-RPC Specification',       false),
    -- Q5: CouchDB concurrency
    ('Which concept describes how CouchDB handles concurrent updates without traditional table-level locks?', 'Pessimistic Concurrency Control',                             false),
    ('Which concept describes how CouchDB handles concurrent updates without traditional table-level locks?', 'Multi-Version Concurrency Control (MVCC) via _rev tags',     true),
    ('Which concept describes how CouchDB handles concurrent updates without traditional table-level locks?', 'Strict ACID Atomicity across multiple documents',             false),
    ('Which concept describes how CouchDB handles concurrent updates without traditional table-level locks?', 'Two-Phase Commit Protocol',                                   false),
    -- Q6: CAP Theorem / CouchDB
    ('According to the CAP Theorem, which two properties does CouchDB prioritize during a network partition?', 'Consistency and Availability',          false),
    ('According to the CAP Theorem, which two properties does CouchDB prioritize during a network partition?', 'Consistency and Partition Tolerance',   false),
    ('According to the CAP Theorem, which two properties does CouchDB prioritize during a network partition?', 'Availability and Partition Tolerance',  true),
    ('According to the CAP Theorem, which two properties does CouchDB prioritize during a network partition?', 'Durability and Atomicity',              false),
    -- Q7: Express middleware next()
    ('In Express.js middleware, what happens if a function does not call next() and does not send a response?', 'The request is automatically passed to the next route handler',  false),
    ('In Express.js middleware, what happens if a function does not call next() and does not send a response?', 'The server will crash and require a restart',                    false),
    ('In Express.js middleware, what happens if a function does not call next() and does not send a response?', 'The request will hang, and the client will eventually time out', true),
    ('In Express.js middleware, what happens if a function does not call next() and does not send a response?', 'Express will return a 404 Not Found error by default',           false),
    -- Q8: Prompt Injection
    ('Which security risk is associated with autonomous agents like OpenClaw?', 'They only run on proprietary cloud servers',                                                false),
    ('Which security risk is associated with autonomous agents like OpenClaw?', 'The Prompt Injection vulnerability where a model executes untrusted commands',             true),
    ('Which security risk is associated with autonomous agents like OpenClaw?', 'They cannot interface with local databases',                                               false),
    ('Which security risk is associated with autonomous agents like OpenClaw?', 'The requirement for manual approval of every single character generated',                  false),
    -- Q9: cors middleware
    ('What is the specific role of the cors middleware package in a Node/Express application?', 'To encrypt data transmitted between the client and server',             false),
    ('What is the specific role of the cors middleware package in a Node/Express application?', 'To provide a whitelist of allowed origins for browser-based requests',  true),
    ('What is the specific role of the cors middleware package in a Node/Express application?', 'To serve static files like images and CSS',                              false),
    ('What is the specific role of the cors middleware package in a Node/Express application?', 'To log every incoming HTTP request for debugging',                       false),
    -- Q10: Chain of Thought
    ('In local LLMs like DeepSeek-R1, what is the function of Chain of Thought (CoT) inside <think> tags?', 'To hide the model''s source code from the end user',                        false),
    ('In local LLMs like DeepSeek-R1, what is the function of Chain of Thought (CoT) inside <think> tags?', 'To allow the model to reason through a problem before providing a final answer', true),
    ('In local LLMs like DeepSeek-R1, what is the function of Chain of Thought (CoT) inside <think> tags?', 'To speed up the generation of the final response tokens',                   false),
    ('In local LLMs like DeepSeek-R1, what is the function of Chain of Thought (CoT) inside <think> tags?', 'To translate the user''s prompt into JSON-RPC format',                      false)
  ) AS v(qtext, opt, correct) ON nq.question_text = v.qtext
  RETURNING question_id
)

SELECT question_id FROM new_options LIMIT 0;

-- ============================================================
-- Tag questions with their topics
-- ============================================================
INSERT INTO question_topics (question_id, topic_id)
SELECT q.id, t.id
FROM questions q
JOIN (VALUES
  -- Q1: RMM Level 1
  ('In the Richardson Maturity Model, what distinguishes a Level 1 API from a Level 0 API?', 'rest'),
  ('In the Richardson Maturity Model, what distinguishes a Level 1 API from a Level 0 API?', 'http'),
  -- Q2: HATEOAS / Uniform Interface
  ('Which REST constraint is most directly addressed by Richardson Maturity Level 3 (HATEOAS)?', 'rest'),
  -- Q3: Quantization / Ollama
  ('When running local LLMs with Ollama, what is the primary purpose of Quantization in model files?', 'cloud'),
  -- Q4: MCP tool executor
  ('In the Model Context Protocol (MCP), which entity is responsible for actually executing a tool?', 'cloud'),
  -- Q5: CouchDB MVCC
  ('Which concept describes how CouchDB handles concurrent updates without traditional table-level locks?', 'sql'),
  ('Which concept describes how CouchDB handles concurrent updates without traditional table-level locks?', 'cloud'),
  -- Q6: CAP Theorem
  ('According to the CAP Theorem, which two properties does CouchDB prioritize during a network partition?', 'sql'),
  ('According to the CAP Theorem, which two properties does CouchDB prioritize during a network partition?', 'cloud'),
  -- Q7: Express middleware next()
  ('In Express.js middleware, what happens if a function does not call next() and does not send a response?', 'node'),
  ('In Express.js middleware, what happens if a function does not call next() and does not send a response?', 'js'),
  -- Q8: Prompt Injection
  ('Which security risk is associated with autonomous agents like OpenClaw?', 'cloud'),
  -- Q9: cors middleware
  ('What is the specific role of the cors middleware package in a Node/Express application?', 'node'),
  ('What is the specific role of the cors middleware package in a Node/Express application?', 'http'),
  -- Q10: Chain of Thought
  ('In local LLMs like DeepSeek-R1, what is the function of Chain of Thought (CoT) inside <think> tags?', 'cloud')
) AS mapping(qtext, slug) ON q.question_text = mapping.qtext
JOIN topics t ON t.slug = mapping.slug
ON CONFLICT DO NOTHING;

COMMIT;
