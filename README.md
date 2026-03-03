# 353 Study Guide

A multiple choice quiz app built with React + Vite to help study for CMPT 353 Winter 2026.

## Running

**With Docker:**
```bash
docker compose up
```
App will be available at `http://localhost`.

## Adding Questions

Edit `question-bank.json`. Each entry follows this format:

```json
{
  "question": "Your question here?",
  "options": ["Option A", "Option B", "Option C", "Option D"],
  "correctAnswer": "Option A"
}
```

Author: Raphael
