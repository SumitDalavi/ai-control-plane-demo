# Architecture — AI Control Plane
> Last updated: 2026-08-29 | Maturity: Full Prototype
> _End-to-end AI request lifecycle with identity, rate-limiting, semantic caching, cost routing, and regression evaluation._

## System Architecture

```mermaid
flowchart TD
    Client(["Client / Demo Script"])

    subgraph Identity ["Identity Layer"]
        NHI["nhi-registry :3001\n/api/authz\n/api/nhis\n/api/audit"]
    end

    subgraph Gateway ["Gateway Layer"]
        GW["llm-gateway :4003\n/v1/chat/completions\n/admin/metrics\nRate Limit + Budget + Fallback"]
    end

    subgraph Cache ["Cache Layer"]
        SC["semantic-cache :4000\n/v1/chat/completions\nVector similarity lookup\nPrometheus :9090"]
        Redis[("Redis :6379")]
        SC <-->|"store/lookup"| Redis
    end

    subgraph Router ["Cost Router"]
        CA["cost-autopilot :3002\n/v1/completions\nClassify complexity → route model"]
        SQLite1[("SQLite\nrouting logs")]
        CA --- SQLite1
    end

    subgraph Guardrails ["SQL Safety"]
        SQL["sql-guardrails :4001\n/api/v1/query\nNL → SQL → DDL block → execute"]
    end

    subgraph Eval ["Quality Gate"]
        RD["regression-detection :5001\n/v1/eval/trigger\nRun evals → detect drop → alert"]
        PG[("Postgres :5432")]
        RD <-->|"eval results"| PG
        NHI <-->|"audit log"| PG
    end

    Prom["Prometheus :9091"]

    Client -->|"Bearer token"| NHI
    NHI -->|"authz OK"| GW
    GW -->|"forward request"| SC
    SC -->|"cache MISS"| CA
    CA -->|"routed to provider"| LLM(["OpenAI / Anthropic"])
    LLM -->|"response"| CA
    CA -->|"response + cost"| SC
    SC -->|"cache stored"| SC
    Client -->|"SQL question"| SQL
    CA -.->|"post-response eval trigger"| RD
    SC -->|"metrics scrape"| Prom
```

## Component Overview

| Component | Port | Description | Tech |
|---|---|---|---|
| `nhi-registry` | `3001` | Non-human identity and policy enforcement. | Node.js |
| `llm-gateway` | `4003` | API gateway for rate limiting, budgets, and fallbacks. | Node.js |
| `semantic-cache` | `4000` | Semantic caching proxy exposing Prometheus metrics (`:9090`). | Node.js / Python |
| `cost-autopilot` | `3002` | Cost classifier and model router. | Node.js / Python |
| `sql-guardrails` | `4001` | SQL generation with DDL guardrails. | Node.js / Python |
| `regression-detection` | `5001` | Evaluation runner and regression alert system. | Node.js / Python |
| `prometheus` | `9091` | Metrics scraper. | Go |

## External Dependencies

| Dependency | Status | Notes |
|---|---|---|
| OpenAI API | **Real** | Used by router for `gpt-4o` and `gpt-4o-mini` routing unless stubbed. |
| Postgres | **Real** | Shared infra DB for NHI identity and regression evaluation. |
| Redis | **Real** | Shared infra caching backend for the semantic cache. |
