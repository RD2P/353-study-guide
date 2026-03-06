-- ============================================================
-- Seed: Containerization questions (14 questions)
-- Requires: 01-init.sql, 03-add-topics.sql already applied.
-- Wrapped in a transaction so it either fully succeeds or rolls back.
-- ============================================================

BEGIN;

WITH new_questions AS (
  INSERT INTO questions (question_text) VALUES
    ('What is the primary purpose of a development environment in software development?'),
    ('Why can local development environments cause problems across different projects?'),
    ('What is the main difference between virtual machines and containers?'),
    ('Why are virtual machines considered more resource intensive than containers?'),
    ('What is the role of a Dockerfile?'),
    ('What is a Docker image?'),
    ('What does the `docker run` command do?'),
    ('Why is the `EXPOSE` instruction used in a Dockerfile?'),
    ('What does the `-p 80:8080` option in `docker run` do?'),
    ('What is the purpose of mounting a volume using the `-v` flag in Docker?'),
    ('What is the main purpose of `docker-compose.yml`?'),
    ('What does the `WORKDIR` instruction in a Dockerfile do?'),
    ('What is the purpose of the `CMD` instruction in a Dockerfile?'),
    ('Why might developers prefer containers over local environments for development?')
  RETURNING id, question_text
),

new_options AS (
  INSERT INTO options (question_id, option_text, is_correct)
  SELECT nq.id, v.opt, v.correct
  FROM new_questions nq
  JOIN (VALUES
    -- Q1
    ('What is the primary purpose of a development environment in software development?', 'To deploy applications to production servers',              false),
    ('What is the primary purpose of a development environment in software development?', 'To provide tools and libraries needed to build and test software', true),
    ('What is the primary purpose of a development environment in software development?', 'To replace operating systems',                              false),
    ('What is the primary purpose of a development environment in software development?', 'To eliminate the need for programming languages',            false),
    -- Q2
    ('Why can local development environments cause problems across different projects?',  'Different projects may require different versions of libraries or dependencies', true),
    ('Why can local development environments cause problems across different projects?',  'Local environments do not support programming languages',     false),
    ('Why can local development environments cause problems across different projects?',  'Operating systems cannot run multiple applications',          false),
    ('Why can local development environments cause problems across different projects?',  'Local environments cannot access networks',                   false),
    -- Q3
    ('What is the main difference between virtual machines and containers?', 'Virtual machines share the host OS kernel while containers run separate operating systems', false),
    ('What is the main difference between virtual machines and containers?', 'Containers include a full operating system while virtual machines do not',                 false),
    ('What is the main difference between virtual machines and containers?', 'Virtual machines emulate hardware and run full operating systems, while containers share the host OS kernel', true),
    ('What is the main difference between virtual machines and containers?', 'Containers cannot run applications',                                                       false),
    -- Q4
    ('Why are virtual machines considered more resource intensive than containers?', 'Each virtual machine runs its own full operating system', true),
    ('Why are virtual machines considered more resource intensive than containers?', 'Virtual machines cannot share files',                    false),
    ('Why are virtual machines considered more resource intensive than containers?', 'Virtual machines require internet access',               false),
    ('Why are virtual machines considered more resource intensive than containers?', 'Containers run faster code',                            false),
    -- Q5
    ('What is the role of a Dockerfile?', 'To run a container instance',                         false),
    ('What is the role of a Dockerfile?', 'To define instructions for building a Docker image',  true),
    ('What is the role of a Dockerfile?', 'To manage container networking only',                  false),
    ('What is the role of a Dockerfile?', 'To replace docker-compose',                           false),
    -- Q6
    ('What is a Docker image?', 'A running container instance',         false),
    ('What is a Docker image?', 'A template used to create containers', true),
    ('What is a Docker image?', 'A Docker configuration file',          false),
    ('What is a Docker image?', 'A network configuration',              false),
    -- Q7
    ('What does the `docker run` command do?', 'Creates a Dockerfile',               false),
    ('What does the `docker run` command do?', 'Builds an image from a Dockerfile',  false),
    ('What does the `docker run` command do?', 'Starts a container from an image',   true),
    ('What does the `docker run` command do?', 'Uploads an image to Docker Hub',     false),
    -- Q8
    ('Why is the `EXPOSE` instruction used in a Dockerfile?', 'To automatically publish a port to the internet',  false),
    ('Why is the `EXPOSE` instruction used in a Dockerfile?', 'To document and enable a container port for use', true),
    ('Why is the `EXPOSE` instruction used in a Dockerfile?', 'To stop containers from using ports',              false),
    ('Why is the `EXPOSE` instruction used in a Dockerfile?', 'To create network drivers',                        false),
    -- Q9
    ('What does the `-p 80:8080` option in `docker run` do?', 'Maps port 8080 on the host to port 80 in the container',  false),
    ('What does the `-p 80:8080` option in `docker run` do?', 'Maps port 80 on the host to port 8080 in the container',  true),
    ('What does the `-p 80:8080` option in `docker run` do?', 'Opens both ports inside the container',                   false),
    ('What does the `-p 80:8080` option in `docker run` do?', 'Disables networking',                                     false),
    -- Q10
    ('What is the purpose of mounting a volume using the `-v` flag in Docker?', 'To delete files inside a container',                    false),
    ('What is the purpose of mounting a volume using the `-v` flag in Docker?', 'To connect a host directory with a container directory', true),
    ('What is the purpose of mounting a volume using the `-v` flag in Docker?', 'To compress container files',                           false),
    ('What is the purpose of mounting a volume using the `-v` flag in Docker?', 'To duplicate containers',                               false),
    -- Q11
    ('What is the main purpose of `docker-compose.yml`?', 'To build a single Docker image',                  false),
    ('What is the main purpose of `docker-compose.yml`?', 'To define and manage multi-container applications', true),
    ('What is the main purpose of `docker-compose.yml`?', 'To replace Dockerfiles',                           false),
    ('What is the main purpose of `docker-compose.yml`?', 'To monitor container CPU usage',                   false),
    -- Q12
    ('What does the `WORKDIR` instruction in a Dockerfile do?', 'Creates a new container',                             false),
    ('What does the `WORKDIR` instruction in a Dockerfile do?', 'Sets the working directory for subsequent commands',   true),
    ('What does the `WORKDIR` instruction in a Dockerfile do?', 'Copies files from the host',                          false),
    ('What does the `WORKDIR` instruction in a Dockerfile do?', 'Defines the container network',                       false),
    -- Q13
    ('What is the purpose of the `CMD` instruction in a Dockerfile?', 'Specifies the default command executed when a container starts', true),
    ('What is the purpose of the `CMD` instruction in a Dockerfile?', 'Installs system packages',                                       false),
    ('What is the purpose of the `CMD` instruction in a Dockerfile?', 'Defines container networking',                                   false),
    ('What is the purpose of the `CMD` instruction in a Dockerfile?', 'Creates volumes automatically',                                  false),
    -- Q14
    ('Why might developers prefer containers over local environments for development?', 'Containers guarantee identical environments across systems', true),
    ('Why might developers prefer containers over local environments for development?', 'Containers eliminate the need for operating systems',       false),
    ('Why might developers prefer containers over local environments for development?', 'Containers remove the need for programming languages',     false),
    ('Why might developers prefer containers over local environments for development?', 'Containers automatically deploy applications',             false)
  ) AS v(qtext, opt, correct) ON nq.question_text = v.qtext
  RETURNING question_id
)

INSERT INTO question_topics (question_id, topic_id)
SELECT DISTINCT no.question_id, t.id
FROM new_options no
JOIN topics t ON t.slug = 'containerization'
ON CONFLICT DO NOTHING;

COMMIT;
