# AI Control Plane

> **Maturity:** Functional Prototype

This composition ties together the NHI Registry, LLM Gateway, Semantic Cache, Cost Autopilot, SQL Guardrails, and Model Regression Detection into a single end-to-end integration demo.

## Prerequisites
- Docker and Docker Compose
- Node.js & npm (for local tests)

## Startup and Teardown
To run the demo locally, use the provided `Makefile`:

```bash
make infra-up    # Starts the shared portfolio infra (Postgres, Redis)
make up          # Builds and starts the AI Control Plane services
make demo        # Runs the end-to-end scenarios
make verify      # Verifies postconditions and collects artifacts
make down        # Tears down the services and infrastructure
```

## Modes
- **Real Mode**: Uses actual provider endpoints for LLMs (requires valid API keys in `.env`).
- **Stub Mode**: (Default) Runs in integration-test mode (`DEMO_MODE=stub`) where external LLM calls are safely stubbed. All internal routing, caching, and database state are real.

## Known Limitations
- The `benchmark` harness uses synthetic/public input, not real production data.
- The `DEMO_MODE=stub` prevents actual cloud API billing, which limits true external end-to-end assertions in CI.
