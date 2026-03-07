-- ============================================================
-- Seed: SQL / React / REST questions (15 questions)
-- Requires: 01-init.sql, 03-add-topics.sql already applied.
-- Wrapped in a transaction so it either fully succeeds or rolls back.
-- ============================================================

BEGIN;

WITH new_questions AS (
  INSERT INTO questions (question_text) VALUES
    ('In the relational model, what term refers to the number of tuples (rows) currently in a relation?'),
    ('Which React hook is primarily used to define a getter and setter for managing state within a component?'),
    ('When using React Router, which component acts as the wrapper for client-side navigation?'),
    ('In SQL, what is the primary difference between a Candidate Key and a Primary Key?'),
    ('What is the result of an INNER JOIN where one student has no enrollments and one enrollment has no matching student?'),
    ('Which SQL JOIN type is commonly referred to as a Cartesian product?'),
    ('At which SQL isolation level is a Dirty Read (reading uncommitted changes) possible?'),
    ('In Next.js App Router, what is a key difference between Server Components and Client Components?'),
    ('Which Richardson Maturity Model level uses resources (URIs) and HTTP verbs but not yet HATEOAS?'),
    ('According to REST principles, which HTTP method is defined as Safe (should not change server state)?'),
    ('What is a major danger of using a NATURAL JOIN in production database code?'),
    ('In a JSON document, which syntax rule differs from standard JavaScript object literals?'),
    ('Which REST constraint requires each request to contain all necessary information (no stored client context)?'),
    ('Which message service style calls named operations like createUser() via a single endpoint?'),
    ('Which HTTP status code should be returned when a new resource is successfully created on the server?')
  RETURNING id, question_text
),

new_options AS (
  INSERT INTO options (question_id, option_text, is_correct)
  SELECT nq.id, v.opt, v.correct
  FROM new_questions nq
  JOIN (VALUES
    -- Q1: cardinality
    ('In the relational model, what term refers to the number of tuples (rows) currently in a relation?', 'Degree',      false),
    ('In the relational model, what term refers to the number of tuples (rows) currently in a relation?', 'Arity',       false),
    ('In the relational model, what term refers to the number of tuples (rows) currently in a relation?', 'Cardinality', true),
    ('In the relational model, what term refers to the number of tuples (rows) currently in a relation?', 'Domain',      false),
    -- Q2: useState
    ('Which React hook is primarily used to define a getter and setter for managing state within a component?', 'useEffect',  false),
    ('Which React hook is primarily used to define a getter and setter for managing state within a component?', 'useContext', false),
    ('Which React hook is primarily used to define a getter and setter for managing state within a component?', 'useReducer', false),
    ('Which React hook is primarily used to define a getter and setter for managing state within a component?', 'useState',   true),
    -- Q3: BrowserRouter
    ('When using React Router, which component acts as the wrapper for client-side navigation?', '<Routes>',       false),
    ('When using React Router, which component acts as the wrapper for client-side navigation?', '<BrowserRouter>', true),
    ('When using React Router, which component acts as the wrapper for client-side navigation?', '<Route>',        false),
    ('When using React Router, which component acts as the wrapper for client-side navigation?', '<Link>',         false),
    -- Q4: candidate key vs primary key
    ('In SQL, what is the primary difference between a Candidate Key and a Primary Key?', 'A candidate key is minimal, while a primary key can include redundant columns.',                      false),
    ('In SQL, what is the primary difference between a Candidate Key and a Primary Key?', 'A primary key is the specific candidate key chosen to uniquely identify tuples in a relation.',        true),
    ('In SQL, what is the primary difference between a Candidate Key and a Primary Key?', 'Primary keys are only used in physical databases, while candidate keys are theoretical.',              false),
    ('In SQL, what is the primary difference between a Candidate Key and a Primary Key?', 'Candidate keys allow NULL values, while primary keys do not.',                                        false),
    -- Q5: INNER JOIN result
    ('What is the result of an INNER JOIN where one student has no enrollments and one enrollment has no matching student?', 'All students are included, with NULLs for missing enrollments.',       false),
    ('What is the result of an INNER JOIN where one student has no enrollments and one enrollment has no matching student?', 'All enrollments are included, with NULLs for missing students.',        false),
    ('What is the result of an INNER JOIN where one student has no enrollments and one enrollment has no matching student?', 'Only the 5 students with matching enrollment records are included.',     true),
    ('What is the result of an INNER JOIN where one student has no enrollments and one enrollment has no matching student?', 'A Cartesian product of all 6 students and all enrollment records.',     false),
    -- Q6: CROSS JOIN
    ('Which SQL JOIN type is commonly referred to as a Cartesian product?', 'NATURAL JOIN',    false),
    ('Which SQL JOIN type is commonly referred to as a Cartesian product?', 'SELF JOIN',       false),
    ('Which SQL JOIN type is commonly referred to as a Cartesian product?', 'CROSS JOIN',      true),
    ('Which SQL JOIN type is commonly referred to as a Cartesian product?', 'FULL OUTER JOIN', false),
    -- Q7: READ UNCOMMITTED
    ('At which SQL isolation level is a Dirty Read (reading uncommitted changes) possible?', 'READ UNCOMMITTED', true),
    ('At which SQL isolation level is a Dirty Read (reading uncommitted changes) possible?', 'READ COMMITTED',   false),
    ('At which SQL isolation level is a Dirty Read (reading uncommitted changes) possible?', 'REPEATABLE READ',  false),
    ('At which SQL isolation level is a Dirty Read (reading uncommitted changes) possible?', 'SERIALIZABLE',     false),
    -- Q8: Server vs Client Components
    ('In Next.js App Router, what is a key difference between Server Components and Client Components?', 'Server Components can use ''useState'', while Client Components cannot.',                         false),
    ('In Next.js App Router, what is a key difference between Server Components and Client Components?', 'Server Components execute only on the server and do not send JavaScript to the client.',           true),
    ('In Next.js App Router, what is a key difference between Server Components and Client Components?', 'Client Components are only for static SEO content.',                                              false),
    ('In Next.js App Router, what is a key difference between Server Components and Client Components?', 'Server Components require a separate ''use server'' directive at the top of the file.',            false),
    -- Q9: Richardson Maturity Level 2
    ('Which Richardson Maturity Model level uses resources (URIs) and HTTP verbs but not yet HATEOAS?', 'Level 0', false),
    ('Which Richardson Maturity Model level uses resources (URIs) and HTTP verbs but not yet HATEOAS?', 'Level 1', false),
    ('Which Richardson Maturity Model level uses resources (URIs) and HTTP verbs but not yet HATEOAS?', 'Level 2', true),
    ('Which Richardson Maturity Model level uses resources (URIs) and HTTP verbs but not yet HATEOAS?', 'Level 3', false),
    -- Q10: safe HTTP method
    ('According to REST principles, which HTTP method is defined as Safe (should not change server state)?', 'POST',   false),
    ('According to REST principles, which HTTP method is defined as Safe (should not change server state)?', 'PUT',    false),
    ('According to REST principles, which HTTP method is defined as Safe (should not change server state)?', 'DELETE', false),
    ('According to REST principles, which HTTP method is defined as Safe (should not change server state)?', 'GET',    true),
    -- Q11: NATURAL JOIN danger
    ('What is a major danger of using a NATURAL JOIN in production database code?', 'It is significantly slower than an INNER JOIN.',                                                              false),
    ('What is a major danger of using a NATURAL JOIN in production database code?', 'It requires a composite primary key to function correctly.',                                                  false),
    ('What is a major danger of using a NATURAL JOIN in production database code?', 'Adding a column with the same name to both tables later will silently change the join condition.',            true),
    ('What is a major danger of using a NATURAL JOIN in production database code?', 'It automatically excludes rows with NULL values in any column.',                                              false),
    -- Q12: JSON double quotes
    ('In a JSON document, which syntax rule differs from standard JavaScript object literals?', 'Keys must be enclosed in double quotes.',                      true),
    ('In a JSON document, which syntax rule differs from standard JavaScript object literals?', 'Trailing commas are required for all objects.',                false),
    ('In a JSON document, which syntax rule differs from standard JavaScript object literals?', 'Single quotes are preferred for string values.',               false),
    ('In a JSON document, which syntax rule differs from standard JavaScript object literals?', 'Comments can be added using the // syntax.',                   false),
    -- Q13: REST Stateless constraint
    ('Which REST constraint requires each request to contain all necessary information (no stored client context)?', 'Layered System',     false),
    ('Which REST constraint requires each request to contain all necessary information (no stored client context)?', 'Stateless',          true),
    ('Which REST constraint requires each request to contain all necessary information (no stored client context)?', 'Cacheable',          false),
    ('Which REST constraint requires each request to contain all necessary information (no stored client context)?', 'Uniform Interface',  false),
    -- Q14: JSON-RPC
    ('Which message service style calls named operations like createUser() via a single endpoint?', 'REST',      false),
    ('Which message service style calls named operations like createUser() via a single endpoint?', 'HATEOAS',   false),
    ('Which message service style calls named operations like createUser() via a single endpoint?', 'JSON-RPC',  true),
    ('Which message service style calls named operations like createUser() via a single endpoint?', 'CRUD',      false),
    -- Q15: 201 Created
    ('Which HTTP status code should be returned when a new resource is successfully created on the server?', '200 OK',           false),
    ('Which HTTP status code should be returned when a new resource is successfully created on the server?', '201 Created',      true),
    ('Which HTTP status code should be returned when a new resource is successfully created on the server?', '204 No Content',   false),
    ('Which HTTP status code should be returned when a new resource is successfully created on the server?', '400 Bad Request',  false)
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
  -- Q1: cardinality
  ('In the relational model, what term refers to the number of tuples (rows) currently in a relation?', 'sql'),
  -- Q2: useState
  ('Which React hook is primarily used to define a getter and setter for managing state within a component?', 'react'),
  ('Which React hook is primarily used to define a getter and setter for managing state within a component?', 'js'),
  -- Q3: BrowserRouter
  ('When using React Router, which component acts as the wrapper for client-side navigation?', 'react'),
  -- Q4: candidate key vs primary key
  ('In SQL, what is the primary difference between a Candidate Key and a Primary Key?', 'sql'),
  -- Q5: INNER JOIN result
  ('What is the result of an INNER JOIN where one student has no enrollments and one enrollment has no matching student?', 'sql'),
  -- Q6: CROSS JOIN
  ('Which SQL JOIN type is commonly referred to as a Cartesian product?', 'sql'),
  -- Q7: dirty read
  ('At which SQL isolation level is a Dirty Read (reading uncommitted changes) possible?', 'sql'),
  -- Q8: Server vs Client Components
  ('In Next.js App Router, what is a key difference between Server Components and Client Components?', 'next'),
  ('In Next.js App Router, what is a key difference between Server Components and Client Components?', 'react'),
  -- Q9: Richardson Maturity Level 2
  ('Which Richardson Maturity Model level uses resources (URIs) and HTTP verbs but not yet HATEOAS?', 'rest'),
  ('Which Richardson Maturity Model level uses resources (URIs) and HTTP verbs but not yet HATEOAS?', 'http'),
  -- Q10: safe HTTP method
  ('According to REST principles, which HTTP method is defined as Safe (should not change server state)?', 'rest'),
  ('According to REST principles, which HTTP method is defined as Safe (should not change server state)?', 'http'),
  -- Q11: NATURAL JOIN danger
  ('What is a major danger of using a NATURAL JOIN in production database code?', 'sql'),
  -- Q12: JSON double quotes
  ('In a JSON document, which syntax rule differs from standard JavaScript object literals?', 'js'),
  -- Q13: REST Stateless
  ('Which REST constraint requires each request to contain all necessary information (no stored client context)?', 'rest'),
  ('Which REST constraint requires each request to contain all necessary information (no stored client context)?', 'http'),
  -- Q14: JSON-RPC
  ('Which message service style calls named operations like createUser() via a single endpoint?', 'rest'),
  ('Which message service style calls named operations like createUser() via a single endpoint?', 'http'),
  -- Q15: 201 Created
  ('Which HTTP status code should be returned when a new resource is successfully created on the server?', 'http'),
  ('Which HTTP status code should be returned when a new resource is successfully created on the server?', 'rest')
) AS mapping(qtext, slug) ON q.question_text = mapping.qtext
JOIN topics t ON t.slug = mapping.slug
ON CONFLICT DO NOTHING;

COMMIT;
