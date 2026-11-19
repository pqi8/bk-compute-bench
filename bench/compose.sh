#!/usr/bin/env bash
. "$(dirname "$0")/lib.sh"
cat > compose.yml <<YAML
services:
  db:
    image: postgres:16
    environment: { POSTGRES_PASSWORD: test }
    healthcheck: { test: ["CMD", "pg_isready", "-U", "postgres"], interval: 2s, retries: 30 }
  cache:
    image: redis:7
    healthcheck: { test: ["CMD", "redis-cli", "ping"], interval: 2s, retries: 30 }
YAML
docker compose up -d --wait
docker compose exec -T db psql -U postgres -c "select version();"
docker compose exec -T cache redis-cli set k v
docker compose down -v
