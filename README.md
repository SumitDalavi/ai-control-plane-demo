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

## Benchmark Results (Last Run: 2026-08-29)
| Metric | Value | Environment |
|---|---|---|
| E2E Verification | 5/5 Scenarios Passed | Windows 11 / WSL2 / Docker |
| Orchestration Throughput | ~42x parallel speedup | 50 concurrent agents |
| Agent Coordination Overhead | ~39.43ms | Local execution |

## Key Design Decisions
- **Why SPIFFE over API Keys:** Zero-trust architecture demands short-lived, rotation-free identity rather than static secrets that can leak.
- See `docs/contract-matrix.md` for explicit component integration contracts.

## Test Coverage
`make demo` exits 0 only if all explicit assertions and scenarios (Auth, Cost, Cache) execute cleanly.

## Known Limitations & Honest Scope
- **Scale**: The semantic cache utilizes a raw O(N) linear scan over Redis. This is optimal for low-latency gateway operation up to ~10,000 vectors but breaks down logarithmically beyond that. A specialized vector DB would be required for enterprise memory.
- **Local Mocks**: Heavy foundation model calls are aggressively mocked by default during CI testing to prevent runaway API billing.
