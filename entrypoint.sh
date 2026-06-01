#!/bin/bash
set -e

<<<<<<< HEAD
export PATH="/root/.local/bin:$PATH"

cd /app

echo "Applying database migrations..."
=======
cd /app

echo "Applying database migrations"
>>>>>>> 854fa84 (alembic fix)
uv run alembic upgrade head

echo "Starting FastAPI application..."
exec uv run python -m bin.api
