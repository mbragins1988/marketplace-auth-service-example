FROM python:3.13-slim-bookworm

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_NO_DEV=1 \
    UV_FROZEN=1 \
    PYTHONPATH=/app \
    PATH="/root/.local/bin:$PATH"

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    curl -LsSf https://astral.sh/uv/install.sh | sh

WORKDIR /app

# Копируем ТОЛЬКО файлы зависимостей.
COPY pyproject.toml uv.lock ./

# Устанавливаем зависимости (этот слой кэшируется, пока не изменился pyproject.toml)
RUN uv sync --frozen --no-install-project --no-dev

# Копируем весь код
COPY . /app/

# Устанавливаем сам проект
RUN uv sync --frozen --no-dev

# Entrypoint
RUN chmod +x /app/entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
