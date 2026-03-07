-- ============================================================
-- Seed: JavaScript / HTML / HTTP questions (30 questions)
-- Requires: 01-init.sql, 03-add-topics.sql already applied.
-- Wrapped in a transaction so it either fully succeeds or rolls back.
-- ============================================================

BEGIN;

WITH new_questions AS (
  INSERT INTO questions (question_text) VALUES
    ('Who is credited with inventing the World Wide Web in 1989?'),
    ('What is a key trend in HTML5 development towards better web standards?'),
    ('In HTML, what does the <!DOCTYPE html> declaration specify?'),
    ('Which of the following is a correct example of a self-closing tag in HTML?'),
    ('What is the purpose of attributes in HTML tags?'),
    ('In CSS, what does a selector like ''.ralph1'' represent?'),
    ('What does the CSS selector ''h1 h2'' select?'),
    ('In the DOM manipulation example, what does document.getElementById(''p1'').innerHTML do?'),
    ('Which layer of the communication stack is responsible for reliable, ordered communication like TCP?'),
    ('What is a key difference between TCP and UDP?'),
    ('How does DNS primarily function in the web?'),
    ('What feature was introduced in HTTP/1.1 to reuse TCP connections?'),
    ('In HTTP/2, what solves head-of-line blocking at the application layer?'),
    ('Which HTTP method is used to submit data to be processed, often from forms?'),
    ('What does it mean for an HTTP method to be ''idempotent''?'),
    ('Which HTTP status code category indicates client errors, like 404?'),
    ('In JavaScript, what is the difference between ''let'' and ''var'' regarding scope?'),
    ('What happens when accessing a ''let'' variable before its declaration due to hoisting?'),
    ('In JavaScript, what does the ''this'' keyword refer to in a method inside an object?'),
    ('Why can''t functions be included in JSON data?'),
    ('In Node.js, what does ''require()'' do?'),
    ('What is the role of ''module.exports'' in Node.js?'),
    ('In a basic Node.js HTTP server, what handles incoming requests?'),
    ('What advantage does Express provide over the built-in HTTP module in Node.js?'),
    ('In Node.js servers, why might server state like a counter reset on restart?'),
    ('What is a conceptual benefit of HTTP/3 using QUIC over UDP?'),
    ('How does nesting work in HTML tags?'),
    ('In CSS, what does the '':hover'' pseudo-class select?'),
    ('What is the primary use of the HEAD HTTP method?'),
    ('In JavaScript, what is an arrow function primarily used for?')
  RETURNING id, question_text
),

new_options AS (
  INSERT INTO options (question_id, option_text, is_correct)
  SELECT nq.id, v.opt, v.correct
  FROM new_questions nq
  JOIN (VALUES
    -- Q2: HTML5 trend
    ('What is a key trend in HTML5 development towards better web standards?', 'Increasing procedural code',                        false),
    ('What is a key trend in HTML5 development towards better web standards?', 'Clearer semantics and declarative constructs',      true),
    ('What is a key trend in HTML5 development towards better web standards?', 'Reducing support for media',                        false),
    ('What is a key trend in HTML5 development towards better web standards?', 'Eliminating compatibility with older versions',     false),
    -- Q3: DOCTYPE
    ('In HTML, what does the <!DOCTYPE html> declaration specify?', 'The character encoding',              false),
    ('In HTML, what does the <!DOCTYPE html> declaration specify?', 'The HTML version to use',             true),
    ('In HTML, what does the <!DOCTYPE html> declaration specify?', 'A comment in the code',               false),
    ('In HTML, what does the <!DOCTYPE html> declaration specify?', 'The root element of the document',    false),
    -- Q4: Self-closing tag
    ('Which of the following is a correct example of a self-closing tag in HTML?', '<p>Text</p>',                false),
    ('Which of the following is a correct example of a self-closing tag in HTML?', '<br>',                       true),
    ('Which of the following is a correct example of a self-closing tag in HTML?', '<head>Content</head>',       false),
    ('Which of the following is a correct example of a self-closing tag in HTML?', '<body>Content</body>',       false),
    -- Q5: Attributes purpose
    ('What is the purpose of attributes in HTML tags?', 'To define the structure of the document',     false),
    ('What is the purpose of attributes in HTML tags?', 'To provide additional information about elements', true),
    ('What is the purpose of attributes in HTML tags?', 'To link external stylesheets',                false),
    ('What is the purpose of attributes in HTML tags?', 'To execute JavaScript code',                  false),
    -- Q6: CSS .ralph1 selector
    ('In CSS, what does a selector like ''.ralph1'' represent?', 'A tag selector',         false),
    ('In CSS, what does a selector like ''.ralph1'' represent?', 'An ID selector',          false),
    ('In CSS, what does a selector like ''.ralph1'' represent?', 'A class selector',        true),
    ('In CSS, what does a selector like ''.ralph1'' represent?', 'A universal selector',    false),
    -- Q7: CSS h1 h2 selector
    ('What does the CSS selector ''h1 h2'' select?', 'h2 elements that are direct children of h1',   false),
    ('What does the CSS selector ''h1 h2'' select?', 'h2 elements that immediately follow h1',        false),
    ('What does the CSS selector ''h1 h2'' select?', 'h2 elements that are descendants of h1',        true),
    ('What does the CSS selector ''h1 h2'' select?', 'All h1 and h2 elements',                        false),
    -- Q8: innerHTML
    ('In the DOM manipulation example, what does document.getElementById(''p1'').innerHTML do?', 'Changes the color of the element',        false),
    ('In the DOM manipulation example, what does document.getElementById(''p1'').innerHTML do?', 'Adds an event listener',                  false),
    ('In the DOM manipulation example, what does document.getElementById(''p1'').innerHTML do?', 'Modifies the text content of the element', true),
    ('In the DOM manipulation example, what does document.getElementById(''p1'').innerHTML do?', 'Removes the element from the DOM',         false),
    -- Q9: Transport layer
    ('Which layer of the communication stack is responsible for reliable, ordered communication like TCP?', 'Physical Layer',          false),
    ('Which layer of the communication stack is responsible for reliable, ordered communication like TCP?', 'Data Link Layer',         false),
    ('Which layer of the communication stack is responsible for reliable, ordered communication like TCP?', 'Network/Internet Layer',  false),
    ('Which layer of the communication stack is responsible for reliable, ordered communication like TCP?', 'Transport Layer',         true),
    -- Q10: TCP vs UDP
    ('What is a key difference between TCP and UDP?', 'TCP provides guaranteed delivery, UDP does not',    true),
    ('What is a key difference between TCP and UDP?', 'UDP is used for web browsing, TCP for video streaming', false),
    ('What is a key difference between TCP and UDP?', 'TCP is faster than UDP',                            false),
    ('What is a key difference between TCP and UDP?', 'UDP ensures ordered delivery, TCP does not',        false),
    -- Q11: DNS
    ('How does DNS primarily function in the web?', 'By translating domain names to IP addresses',  true),
    ('How does DNS primarily function in the web?', 'By encrypting data transmissions',             false),
    ('How does DNS primarily function in the web?', 'By managing HTTP requests',                    false),
    ('How does DNS primarily function in the web?', 'By storing web page content',                  false),
    -- Q12: HTTP/1.1 keep-alive
    ('What feature was introduced in HTTP/1.1 to reuse TCP connections?', 'Pipelining',    false),
    ('What feature was introduced in HTTP/1.1 to reuse TCP connections?', 'Keep-alive',    true),
    ('What feature was introduced in HTTP/1.1 to reuse TCP connections?', 'Streams',       false),
    ('What feature was introduced in HTTP/1.1 to reuse TCP connections?', 'QUIC',          false),
    -- Q13: HTTP/2 head-of-line
    ('In HTTP/2, what solves head-of-line blocking at the application layer?', 'Multiple TCP connections',               false),
    ('In HTTP/2, what solves head-of-line blocking at the application layer?', 'QUIC protocol',                         false),
    ('In HTTP/2, what solves head-of-line blocking at the application layer?', 'Streams for multiplexing requests',      true),
    ('In HTTP/2, what solves head-of-line blocking at the application layer?', 'Pipelining without ordering',            false),
    -- Q14: POST method
    ('Which HTTP method is used to submit data to be processed, often from forms?', 'GET',     false),
    ('Which HTTP method is used to submit data to be processed, often from forms?', 'HEAD',    false),
    ('Which HTTP method is used to submit data to be processed, often from forms?', 'POST',    true),
    ('Which HTTP method is used to submit data to be processed, often from forms?', 'DELETE',  false),
    -- Q15: Idempotent
    ('What does it mean for an HTTP method to be ''idempotent''?', 'It can be cached by browsers',                                     false),
    ('What does it mean for an HTTP method to be ''idempotent''?', 'It always changes the server state',                               false),
    ('What does it mean for an HTTP method to be ''idempotent''?', 'Multiple invocations don''t change the response beyond the first', true),
    ('What does it mean for an HTTP method to be ''idempotent''?', 'It is safe for read-only operations',                              false),
    -- Q16: 4xx status codes
    ('Which HTTP status code category indicates client errors, like 404?', '1xx',  false),
    ('Which HTTP status code category indicates client errors, like 404?', '2xx',  false),
    ('Which HTTP status code category indicates client errors, like 404?', '3xx',  false),
    ('Which HTTP status code category indicates client errors, like 404?', '4xx',  true),
    -- Q17: let vs var
    ('In JavaScript, what is the difference between ''let'' and ''var'' regarding scope?', 'let is function-scoped, var is block-scoped',  false),
    ('In JavaScript, what is the difference between ''let'' and ''var'' regarding scope?', 'let is block-scoped, var is function-scoped',  true),
    ('In JavaScript, what is the difference between ''let'' and ''var'' regarding scope?', 'Both are globally scoped',                    false),
    ('In JavaScript, what is the difference between ''let'' and ''var'' regarding scope?', 'var allows hoisting, let does not',           false),
    -- Q18: Temporal Dead Zone
    ('What happens when accessing a ''let'' variable before its declaration due to hoisting?', 'It returns undefined',                             false),
    ('What happens when accessing a ''let'' variable before its declaration due to hoisting?', 'It causes a ReferenceError (Temporal Dead Zone)', true),
    ('What happens when accessing a ''let'' variable before its declaration due to hoisting?', 'It initializes to null',                          false),
    ('What happens when accessing a ''let'' variable before its declaration due to hoisting?', 'It works like var',                               false),
    -- Q19: this keyword
    ('In JavaScript, what does the ''this'' keyword refer to in a method inside an object?', 'The global object',                    false),
    ('In JavaScript, what does the ''this'' keyword refer to in a method inside an object?', 'The function itself',                  false),
    ('In JavaScript, what does the ''this'' keyword refer to in a method inside an object?', 'The object the method is called on',   true),
    ('In JavaScript, what does the ''this'' keyword refer to in a method inside an object?', 'The parent function',                  false),
    -- Q20: JSON and functions
    ('Why can''t functions be included in JSON data?', 'JSON is a text format for data only',   true),
    ('Why can''t functions be included in JSON data?', 'Functions are not serializable',         false),
    ('Why can''t functions be included in JSON data?', 'JSON.parse ignores functions',           false),
    ('Why can''t functions be included in JSON data?', 'All of the above',                       false),
    -- Q21: require()
    ('In Node.js, what does ''require()'' do?', 'Executes a function immediately',                false),
    ('In Node.js, what does ''require()'' do?', 'Loads and returns exports from another module',  true),
    ('In Node.js, what does ''require()'' do?', 'Creates a new server',                           false),
    ('In Node.js, what does ''require()'' do?', 'Parses JSON data',                               false),
    -- Q22: module.exports
    ('What is the role of ''module.exports'' in Node.js?', 'To import modules',                          false),
    ('What is the role of ''module.exports'' in Node.js?', 'To define what a module exposes to others',  true),
    ('What is the role of ''module.exports'' in Node.js?', 'To run the server',                          false),
    ('What is the role of ''module.exports'' in Node.js?', 'To handle HTTP requests',                    false),
    -- Q23: Node.js HTTP server
    ('In a basic Node.js HTTP server, what handles incoming requests?', 'A callback function in createServer',   true),
    ('In a basic Node.js HTTP server, what handles incoming requests?', 'The Express framework automatically',   false),
    ('In a basic Node.js HTTP server, what handles incoming requests?', 'JSON.stringify',                        false),
    ('In a basic Node.js HTTP server, what handles incoming requests?', 'module.exports',                        false),
    -- Q24: Express advantage
    ('What advantage does Express provide over the built-in HTTP module in Node.js?', 'It handles DNS resolution',              false),
    ('What advantage does Express provide over the built-in HTTP module in Node.js?', 'It simplifies routing and middleware',   true),
    ('What advantage does Express provide over the built-in HTTP module in Node.js?', 'It compiles JavaScript to machine code', false),
    ('What advantage does Express provide over the built-in HTTP module in Node.js?', 'It manages database connections',        false),
    -- Q25: Server state reset
    ('In Node.js servers, why might server state like a counter reset on restart?', 'State is stored in memory per process',  true),
    ('In Node.js servers, why might server state like a counter reset on restart?', 'HTTP is stateless',                      false),
    ('In Node.js servers, why might server state like a counter reset on restart?', 'DNS caching',                            false),
    ('In Node.js servers, why might server state like a counter reset on restart?', 'JSON parsing errors',                    false),
    -- Q26: HTTP/3 QUIC benefit
    ('What is a conceptual benefit of HTTP/3 using QUIC over UDP?', 'It guarantees packet order',                           false),
    ('What is a conceptual benefit of HTTP/3 using QUIC over UDP?', 'It reduces head-of-line blocking across streams',     true),
    ('What is a conceptual benefit of HTTP/3 using QUIC over UDP?', 'It requires new TCP connections per request',          false),
    ('What is a conceptual benefit of HTTP/3 using QUIC over UDP?', 'It only supports GET methods',                         false),
    -- Q27: HTML nesting
    ('How does nesting work in HTML tags?', 'Tags cannot be nested',                     false),
    ('How does nesting work in HTML tags?', 'Inner tags must close before outer ones',   true),
    ('How does nesting work in HTML tags?', 'Nesting is only for styles',                false),
    ('How does nesting work in HTML tags?', 'All tags must be self-closing',             false),
    -- Q28: :hover pseudo-class
    ('In CSS, what does the '':hover'' pseudo-class select?', 'Visited links',                      false),
    ('In CSS, what does the '':hover'' pseudo-class select?', 'Active links',                       false),
    ('In CSS, what does the '':hover'' pseudo-class select?', 'Elements with mouse over them',      true),
    ('In CSS, what does the '':hover'' pseudo-class select?', 'Unvisited links',                    false),
    -- Q29: HEAD method
    ('What is the primary use of the HEAD HTTP method?', 'To retrieve full resource content',          false),
    ('What is the primary use of the HEAD HTTP method?', 'To get meta-information without the body',   true),
    ('What is the primary use of the HEAD HTTP method?', 'To submit form data',                        false),
    ('What is the primary use of the HEAD HTTP method?', 'To delete a resource',                       false),
    -- Q30: Arrow functions
    ('In JavaScript, what is an arrow function primarily used for?', 'To define classes',                                    false),
    ('In JavaScript, what is an arrow function primarily used for?', 'Concise function expressions with lexical ''this''',  true),
    ('In JavaScript, what is an arrow function primarily used for?', 'To handle loops',                                      false),
    ('In JavaScript, what is an arrow function primarily used for?', 'To parse JSON',                                        false)
  ) AS v(qtext, opt, correct) ON nq.question_text = v.qtext
  RETURNING question_id
)

-- Close the CTE (dummy select not needed; use the RETURNING from new_options)
SELECT question_id FROM new_options LIMIT 0;

-- ============================================================
-- Tag questions with their topics
-- ============================================================
INSERT INTO question_topics (question_id, topic_id)
SELECT q.id, t.id
FROM questions q
JOIN (VALUES
  -- Q1: WWW inventor
  ('Who is credited with inventing the World Wide Web in 1989?',                                                      'html'),
  ('Who is credited with inventing the World Wide Web in 1989?',                                                      'http'),
  -- Q2: HTML5 trend
  ('What is a key trend in HTML5 development towards better web standards?',                                          'html'),
  -- Q3: DOCTYPE
  ('In HTML, what does the <!DOCTYPE html> declaration specify?',                                                     'html'),
  -- Q4: self-closing tag
  ('Which of the following is a correct example of a self-closing tag in HTML?',                                      'html'),
  -- Q5: attributes
  ('What is the purpose of attributes in HTML tags?',                                                                 'html'),
  -- Q6: CSS class selector
  ('In CSS, what does a selector like ''.ralph1'' represent?',                                                        'css'),
  -- Q7: CSS descendant selector
  ('What does the CSS selector ''h1 h2'' select?',                                                                    'css'),
  -- Q8: DOM innerHTML
  ('In the DOM manipulation example, what does document.getElementById(''p1'').innerHTML do?',                        'js'),
  ('In the DOM manipulation example, what does document.getElementById(''p1'').innerHTML do?',                        'html'),
  -- Q9: transport layer
  ('Which layer of the communication stack is responsible for reliable, ordered communication like TCP?',             'http'),
  -- Q10: TCP vs UDP
  ('What is a key difference between TCP and UDP?',                                                                   'http'),
  -- Q11: DNS
  ('How does DNS primarily function in the web?',                                                                     'http'),
  -- Q12: keep-alive
  ('What feature was introduced in HTTP/1.1 to reuse TCP connections?',                                               'http'),
  -- Q13: HTTP/2 streams
  ('In HTTP/2, what solves head-of-line blocking at the application layer?',                                          'http'),
  -- Q14: POST
  ('Which HTTP method is used to submit data to be processed, often from forms?',                                     'http'),
  ('Which HTTP method is used to submit data to be processed, often from forms?',                                     'rest'),
  -- Q15: idempotent
  ('What does it mean for an HTTP method to be ''idempotent''?',                                                      'http'),
  ('What does it mean for an HTTP method to be ''idempotent''?',                                                      'rest'),
  -- Q16: 4xx
  ('Which HTTP status code category indicates client errors, like 404?',                                              'http'),
  -- Q17: let vs var
  ('In JavaScript, what is the difference between ''let'' and ''var'' regarding scope?',                              'js'),
  -- Q18: TDZ
  ('What happens when accessing a ''let'' variable before its declaration due to hoisting?',                          'js'),
  -- Q19: this keyword
  ('In JavaScript, what does the ''this'' keyword refer to in a method inside an object?',                            'js'),
  -- Q20: JSON no functions
  ('Why can''t functions be included in JSON data?',                                                                  'js'),
  -- Q21: require()
  ('In Node.js, what does ''require()'' do?',                                                                         'js'),
  ('In Node.js, what does ''require()'' do?',                                                                         'node'),
  -- Q22: module.exports
  ('What is the role of ''module.exports'' in Node.js?',                                                              'js'),
  ('What is the role of ''module.exports'' in Node.js?',                                                              'node'),
  -- Q23: Node.js HTTP server
  ('In a basic Node.js HTTP server, what handles incoming requests?',                                                 'js'),
  ('In a basic Node.js HTTP server, what handles incoming requests?',                                                 'node'),
  ('In a basic Node.js HTTP server, what handles incoming requests?',                                                 'http'),
  -- Q24: Express advantage
  ('What advantage does Express provide over the built-in HTTP module in Node.js?',                                   'js'),
  ('What advantage does Express provide over the built-in HTTP module in Node.js?',                                   'node'),
  -- Q25: server state reset
  ('In Node.js servers, why might server state like a counter reset on restart?',                                     'js'),
  ('In Node.js servers, why might server state like a counter reset on restart?',                                     'node'),
  -- Q26: HTTP/3 QUIC
  ('What is a conceptual benefit of HTTP/3 using QUIC over UDP?',                                                     'http'),
  -- Q27: HTML nesting
  ('How does nesting work in HTML tags?',                                                                             'html'),
  -- Q28: :hover
  ('In CSS, what does the '':hover'' pseudo-class select?',                                                           'css'),
  -- Q29: HEAD method
  ('What is the primary use of the HEAD HTTP method?',                                                                'http'),
  ('What is the primary use of the HEAD HTTP method?',                                                                'rest'),
  -- Q30: arrow functions
  ('In JavaScript, what is an arrow function primarily used for?',                                                    'js')
) AS mapping(qtext, slug) ON q.question_text = mapping.qtext
JOIN topics t ON t.slug = mapping.slug
ON CONFLICT DO NOTHING;

COMMIT;
