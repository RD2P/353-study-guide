# 353 Study Guide

An interactive multiple choice quiz app to help study for CMPT 353 Winter 2026.

## Features

- Multiple choice questions with instant feedback
- Tracks score across the current session
- Questions and answers stored in PostgreSQL

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)

## Setup

### 1. Clone the repo

```bash
git clone https://github.com/RD2P/353-study-guide.git
cd 353-study-guide
```

### 2. Create environment files

Create `backend/.env` and choose a username and password for the database:

```
DATABASE_URL=postgres://<user>:<password>@db:5432/quiz
POSTGRES_USER=<user>
POSTGRES_PASSWORD=<password>
POSTGRES_DB=quiz
NODE_ENV=DEV
```

Create `frontend/.env.local`:

```
VITE_API_URL=http://localhost:81
```

### 3. Build and start the containers

```bash
docker compose up -d
```

This builds the frontend and backend images and starts all three services
(frontend, backend, Postgres). On first boot, Postgres automatically creates
the tables and seeds the data via `backend/scripts/01-init.sql` and
`backend/scripts/02-seed.sql`. No manual seeding step required.

### 4. Open the app

Frontend: http://localhost  
Backend API: http://localhost:81

## Connecting to the database

You can inspect the database with a client like [DBeaver](https://dbeaver.io/).
Use these settings (substitute the credentials you chose in step 2):

| Field    | Value     |
|----------|-----------|
| Host     | localhost |
| Port     | 5432      |
| Database | quiz      |
| Username | \<user\>  |
| Password | \<password\> |

## Contributing

Questions are managed in `backend/scripts/02-seed.sql`. After editing the file,
reset the database to re-seed:

```bash
docker compose down -v
docker compose up -d
```

Author: Raphael
