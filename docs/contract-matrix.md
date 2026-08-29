# Component Contract Matrix

| Service | Image/build context | Port | Health/readiness endpoint | Required env | Primary demo endpoint | Dependency |
|---|---|---:|---|---|---|---|
| NHI Registry | `../nhi-agent-access-governance/registry-api` | 3001 | `GET /health` | `POSTGRES_HOST`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` | `GET /api/v1/nhi` | `postgres` |
| LLM Gateway | `../llm-gateway-observability/server` | 4003 | `GET /health` | None | `POST /v1/completions` | `nhi-registry` |
| Semantic Cache | `../semantic-llm-cache` | 4000 | `GET /health` | `REDIS_HOST` | `POST /v1/chat/completions` | `redis`, `llm-gateway` |
| Cost Autopilot | `../llm-cost-autopilot` | 3002 | `GET /health` | None | `POST /v1/completions` | `semantic-cache` |
| SQL Guardrails | `../text-to-sql-guardrails/server` | 4001 | `GET /health` | None | `POST /v1/validate` | None |
| Regression Detection | `../model-regression-detection` | 5001 | `GET /health` | `POSTGRES_HOST`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` | `POST /v1/eval/trigger` | `postgres` |
| Prometheus | `prom/prometheus` | 9091 | `GET /-/healthy` | None | `GET /` | `semantic-cache` |
