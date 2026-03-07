-- ============================================================
-- Seed: JavaScript / TypeScript / React questions (27 questions)
-- Requires: 01-init.sql, 03-add-topics.sql already applied.
-- Wrapped in a transaction so it either fully succeeds or rolls back.
-- ============================================================

BEGIN;

WITH new_questions AS (
  INSERT INTO questions (question_text) VALUES
    ('In the provided Dockerfile example, what is the base image used?'),
    ('What command is used to start the Docker container in detached mode?'),
    ('In Express.js, what endpoint returns ''hello''?'),
    ('What is the purpose of ''app.use(''/'', express.static(''pages''));'' in Express?'),
    ('What API is referenced for asynchronous calls in the browser?'),
    ('Which chapter in the JS Book covers Promises?'),
    ('What is the focus of Chapter 30 in the JS Book?'),
    ('Who started the personal project that became the Web in 1989?'),
    ('What is Ted Nelson associated with in hypertext history?'),
    ('What tool is recommended for simple load testing in Node.js?'),
    ('How is loadtest installed globally via npm?'),
    ('What flag specifies the HTTP method as POST in the loadtest CLI?'),
    ('What rule should be kept in mind for JS execution order?'),
    ('What Node.js version is recommended for using the built-in fetch?'),
    ('Which component handles asynchronous operations like I/O in the JS runtime?'),
    ('What is the role of the Event Loop in the JS runtime?'),
    ('When was TypeScript 1.0 announced?'),
    ('What is a key design choice of TypeScript?'),
    ('In what year was React open-sourced?'),
    ('What is a core design goal of React?'),
    ('How is UI written in React?'),
    ('What command creates a Vite + React + TypeScript project?'),
    ('In React, what are props most like?'),
    ('Why is the ''children'' prop useful in React?'),
    ('What does the React Compiler often replace?'),
    ('What hook is used for ''fetch on mount'' in React components?'),
    ('Why check ''res.ok'' before ''res.json()'' in a fetch call?')
  RETURNING id, question_text
),

new_options AS (
  INSERT INTO options (question_id, option_text, is_correct)
  SELECT nq.id, v.opt, v.correct
  FROM new_questions nq
  JOIN (VALUES
    -- Q1: base image
    ('In the provided Dockerfile example, what is the base image used?', 'node:alpine',   false),
    ('In the provided Dockerfile example, what is the base image used?', 'node:latest',   true),
    ('In the provided Dockerfile example, what is the base image used?', 'ubuntu:latest', false),
    ('In the provided Dockerfile example, what is the base image used?', 'python:3.9',    false),
    -- Q2: detached mode
    ('What command is used to start the Docker container in detached mode?', 'docker run -d',        false),
    ('What command is used to start the Docker container in detached mode?', 'docker-compose up -d', true),
    ('What command is used to start the Docker container in detached mode?', 'docker start',         false),
    ('What command is used to start the Docker container in detached mode?', 'npm start',            false),
    -- Q3: Express endpoint
    ('In Express.js, what endpoint returns ''hello''?', '/hello',    false),
    ('In Express.js, what endpoint returns ''hello''?', '/greeting', true),
    ('In Express.js, what endpoint returns ''hello''?', '/',         false),
    ('In Express.js, what endpoint returns ''hello''?', '/state',    false),
    -- Q4: express.static
    ('What is the purpose of ''app.use(''/'', express.static(''pages''));'' in Express?', 'To handle dynamic routes',                        false),
    ('What is the purpose of ''app.use(''/'', express.static(''pages''));'' in Express?', 'To serve static files from the ''pages'' directory', true),
    ('What is the purpose of ''app.use(''/'', express.static(''pages''));'' in Express?', 'To connect to a database',                          false),
    ('What is the purpose of ''app.use(''/'', express.static(''pages''));'' in Express?', 'To parse JSON requests',                            false),
    -- Q5: Fetch API
    ('What API is referenced for asynchronous calls in the browser?', 'Axios',            false),
    ('What API is referenced for asynchronous calls in the browser?', 'jQuery.ajax',      false),
    ('What API is referenced for asynchronous calls in the browser?', 'Fetch API',        true),
    ('What API is referenced for asynchronous calls in the browser?', 'XMLHttpRequest',   false),
    -- Q6: Promises chapter
    ('Which chapter in the JS Book covers Promises?', 'Chapter 29', false),
    ('Which chapter in the JS Book covers Promises?', 'Chapter 30', false),
    ('Which chapter in the JS Book covers Promises?', 'Chapter 42', true),
    ('Which chapter in the JS Book covers Promises?', 'Chapter 21', false),
    -- Q7: Chapter 30 focus
    ('What is the focus of Chapter 30 in the JS Book?', 'Callbacks',           false),
    ('What is the focus of Chapter 30 in the JS Book?', 'Interval & Timeouts', true),
    ('What is the focus of Chapter 30 in the JS Book?', 'Promises',            false),
    ('What is the focus of Chapter 30 in the JS Book?', 'Async/Await',         false),
    -- Q8: WWW inventor
    ('Who started the personal project that became the Web in 1989?', 'Ted Nelson',       false),
    ('Who started the personal project that became the Web in 1989?', 'Vannevar Bush',    false),
    ('Who started the personal project that became the Web in 1989?', 'Tim Berners-Lee',  true),
    ('Who started the personal project that became the Web in 1989?', 'Jorge Luis Borges',false),
    -- Q9: Ted Nelson
    ('What is Ted Nelson associated with in hypertext history?', 'Memex',                  false),
    ('What is Ted Nelson associated with in hypertext history?', 'Xanadu',                 true),
    ('What is Ted Nelson associated with in hypertext history?', 'Book-Wheel',             false),
    ('What is Ted Nelson associated with in hypertext history?', 'The Garden of Forking Paths', false),
    -- Q10: load testing tool
    ('What tool is recommended for simple load testing in Node.js?', 'JMeter',       false),
    ('What tool is recommended for simple load testing in Node.js?', 'Loadtest',     true),
    ('What tool is recommended for simple load testing in Node.js?', 'Gatling',      false),
    ('What tool is recommended for simple load testing in Node.js?', 'Apache Bench', false),
    -- Q11: install loadtest
    ('How is loadtest installed globally via npm?', 'npm install loadtest',    false),
    ('How is loadtest installed globally via npm?', 'npm install -g loadtest', true),
    ('How is loadtest installed globally via npm?', 'pip install loadtest',    false),
    ('How is loadtest installed globally via npm?', 'yarn add loadtest',       false),
    -- Q12: loadtest POST flag
    ('What flag specifies the HTTP method as POST in the loadtest CLI?', '-method POST', false),
    ('What flag specifies the HTTP method as POST in the loadtest CLI?', '-m POST',      true),
    ('What flag specifies the HTTP method as POST in the loadtest CLI?', '-type POST',   false),
    ('What flag specifies the HTTP method as POST in the loadtest CLI?', '-http POST',   false),
    -- Q13: JS execution order
    ('What rule should be kept in mind for JS execution order?', 'Async first, then sync',                  false),
    ('What rule should be kept in mind for JS execution order?', 'Sync first, then microtasks, then timers', true),
    ('What rule should be kept in mind for JS execution order?', 'Timers first, then microtasks',            false),
    ('What rule should be kept in mind for JS execution order?', 'Microtasks first, then sync',              false),
    -- Q14: Node.js fetch version
    ('What Node.js version is recommended for using the built-in fetch?', 'Node 16+', false),
    ('What Node.js version is recommended for using the built-in fetch?', 'Node 18+', true),
    ('What Node.js version is recommended for using the built-in fetch?', 'Node 14+', false),
    ('What Node.js version is recommended for using the built-in fetch?', 'Node 20+', false),
    -- Q15: Node API / async ops
    ('Which component handles asynchronous operations like I/O in the JS runtime?', 'Call Stack',  false),
    ('Which component handles asynchronous operations like I/O in the JS runtime?', 'Node API',    true),
    ('Which component handles asynchronous operations like I/O in the JS runtime?', 'Microtasks',  false),
    ('Which component handles asynchronous operations like I/O in the JS runtime?', 'Event Loop',  false),
    -- Q16: Event Loop role
    ('What is the role of the Event Loop in the JS runtime?', 'To execute synchronous code',                            false),
    ('What is the role of the Event Loop in the JS runtime?', 'To manage the call stack',                               false),
    ('What is the role of the Event Loop in the JS runtime?', 'To move tasks from queues to the call stack when it''s empty', true),
    ('What is the role of the Event Loop in the JS runtime?', 'To handle memory allocation',                            false),
    -- Q17: TypeScript 1.0
    ('When was TypeScript 1.0 announced?', '2012', false),
    ('When was TypeScript 1.0 announced?', '2014', true),
    ('When was TypeScript 1.0 announced?', '2016', false),
    ('When was TypeScript 1.0 announced?', '2010', false),
    -- Q18: TypeScript design
    ('What is a key design choice of TypeScript?', 'It runs natively in browsers',          false),
    ('What is a key design choice of TypeScript?', 'It compiles to JS with no new runtime', true),
    ('What is a key design choice of TypeScript?', 'It replaces JavaScript entirely',       false),
    ('What is a key design choice of TypeScript?', 'It adds a new virtual machine',         false),
    -- Q19: React open-sourced
    ('In what year was React open-sourced?', '2011', false),
    ('In what year was React open-sourced?', '2012', false),
    ('In what year was React open-sourced?', '2013', true),
    ('In what year was React open-sourced?', '2014', false),
    -- Q20: React core design goal
    ('What is a core design goal of React?', 'Separation of UI and logic',            false),
    ('What is a core design goal of React?', 'Encapsulation: UI + logic live together', true),
    ('What is a core design goal of React?', 'Global state management by default',     false),
    ('What is a core design goal of React?', 'Imperative rendering',                   false),
    -- Q21: UI as function of state
    ('How is UI written in React?', 'As a sequence of DOM manipulations', false),
    ('How is UI written in React?', 'As a function of state (declarative)', true),
    ('How is UI written in React?', 'Using templates',                      false),
    ('How is UI written in React?', 'With direct HTML strings',             false),
    -- Q22: Vite + React + TS command
    ('What command creates a Vite + React + TypeScript project?', 'npm init react-app',                   false),
    ('What command creates a Vite + React + TypeScript project?', 'npm create vite@latest my-react-app',  true),
    ('What command creates a Vite + React + TypeScript project?', 'create-react-app my-app',              false),
    ('What command creates a Vite + React + TypeScript project?', 'vite create my-app',                   false),
    -- Q23: props
    ('In React, what are props most like?', 'Global variables',     false),
    ('In React, what are props most like?', 'Function parameters',  true),
    ('In React, what are props most like?', 'Class fields',         false),
    ('In React, what are props most like?', 'Event handlers',       false),
    -- Q24: children prop
    ('Why is the ''children'' prop useful in React?', 'To pass styles',                false),
    ('Why is the ''children'' prop useful in React?', 'To wrap arbitrary nested UI',   true),
    ('Why is the ''children'' prop useful in React?', 'To handle events',              false),
    ('Why is the ''children'' prop useful in React?', 'To manage state',               false),
    -- Q25: React Compiler
    ('What does the React Compiler often replace?', 'useState and useEffect',         false),
    ('What does the React Compiler often replace?', 'useMemo, useCallback, React.memo', true),
    ('What does the React Compiler often replace?', 'fetch and async/await',          false),
    ('What does the React Compiler often replace?', 'Components and props',           false),
    -- Q26: fetch on mount hook
    ('What hook is used for ''fetch on mount'' in React components?', 'useState',     false),
    ('What hook is used for ''fetch on mount'' in React components?', 'useEffect',    true),
    ('What hook is used for ''fetch on mount'' in React components?', 'useCallback',  false),
    ('What hook is used for ''fetch on mount'' in React components?', 'useMemo',      false),
    -- Q27: res.ok check
    ('Why check ''res.ok'' before ''res.json()'' in a fetch call?', 'To parse JSON early',                  false),
    ('Why check ''res.ok'' before ''res.json()'' in a fetch call?', 'fetch doesn''t reject on HTTP errors', true),
    ('Why check ''res.ok'' before ''res.json()'' in a fetch call?', 'To handle CORS',                       false),
    ('Why check ''res.ok'' before ''res.json()'' in a fetch call?', 'To cache the response',                false)
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
  -- Q1: Dockerfile base image
  ('In the provided Dockerfile example, what is the base image used?',                          'node'),
  -- Q2: detached mode
  ('What command is used to start the Docker container in detached mode?',                      'node'),
  -- Q3: Express endpoint
  ('In Express.js, what endpoint returns ''hello''?',                                            'node'),
  -- Q4: express.static
  ('What is the purpose of ''app.use(''/'', express.static(''pages''));'' in Express?',          'node'),
  -- Q5: Fetch API
  ('What API is referenced for asynchronous calls in the browser?',                             'js'),
  ('What API is referenced for asynchronous calls in the browser?',                             'http'),
  -- Q6: Promises chapter
  ('Which chapter in the JS Book covers Promises?',                                             'js'),
  -- Q7: Chapter 30 focus
  ('What is the focus of Chapter 30 in the JS Book?',                                           'js'),
  -- Q8: WWW inventor
  ('Who started the personal project that became the Web in 1989?',                             'html'),
  ('Who started the personal project that became the Web in 1989?',                             'http'),
  -- Q9: Ted Nelson
  ('What is Ted Nelson associated with in hypertext history?',                                  'html'),
  -- Q10: load testing tool
  ('What tool is recommended for simple load testing in Node.js?',                              'node'),
  -- Q11: install loadtest
  ('How is loadtest installed globally via npm?',                                               'node'),
  -- Q12: loadtest POST flag
  ('What flag specifies the HTTP method as POST in the loadtest CLI?',                          'node'),
  ('What flag specifies the HTTP method as POST in the loadtest CLI?',                          'http'),
  -- Q13: JS execution order
  ('What rule should be kept in mind for JS execution order?',                                  'js'),
  -- Q14: Node.js fetch version
  ('What Node.js version is recommended for using the built-in fetch?',                        'js'),
  ('What Node.js version is recommended for using the built-in fetch?',                        'node'),
  -- Q15: Node API
  ('Which component handles asynchronous operations like I/O in the JS runtime?',              'js'),
  ('Which component handles asynchronous operations like I/O in the JS runtime?',              'node'),
  -- Q16: Event Loop
  ('What is the role of the Event Loop in the JS runtime?',                                    'js'),
  ('What is the role of the Event Loop in the JS runtime?',                                    'node'),
  -- Q17: TypeScript 1.0
  ('When was TypeScript 1.0 announced?',                                                       'js'),
  -- Q18: TypeScript design
  ('What is a key design choice of TypeScript?',                                               'js'),
  -- Q19: React open-sourced
  ('In what year was React open-sourced?',                                                     'react'),
  -- Q20: React design goal
  ('What is a core design goal of React?',                                                     'react'),
  -- Q21: UI as function of state
  ('How is UI written in React?',                                                              'react'),
  -- Q22: Vite + React + TS command
  ('What command creates a Vite + React + TypeScript project?',                                'react'),
  -- Q23: props
  ('In React, what are props most like?',                                                      'react'),
  -- Q24: children prop
  ('Why is the ''children'' prop useful in React?',                                             'react'),
  -- Q25: React Compiler
  ('What does the React Compiler often replace?',                                              'react'),
  -- Q26: useEffect
  ('What hook is used for ''fetch on mount'' in React components?',                             'react'),
  ('What hook is used for ''fetch on mount'' in React components?',                             'js'),
  -- Q27: res.ok
  ('Why check ''res.ok'' before ''res.json()'' in a fetch call?',                               'js'),
  ('Why check ''res.ok'' before ''res.json()'' in a fetch call?',                               'http'),
  ('Why check ''res.ok'' before ''res.json()'' in a fetch call?',                               'react')
) AS mapping(qtext, slug) ON q.question_text = mapping.qtext
JOIN topics t ON t.slug = mapping.slug
ON CONFLICT DO NOTHING;

COMMIT;
