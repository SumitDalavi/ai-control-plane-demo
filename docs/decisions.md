# Decisions

## ADR-001: CI Database Strategy
**Date:** 2026-08-29  
**Status:** Accepted

**Context:**  
The demo tests require a PostgreSQL database. The GitHub Actions ubuntu-latest runner comes with a pre-installed Postgres instance on port 5432, which creates conflicts when spinning up our own service container.

**Decision:**  
We will map the CI test database service container to port 5433 and inject the schema via `psql` before the Jest test suite runs.

**Consequences:**  
- ✅ Positive outcome: Avoids port collisions and ensures a clean, isolated schema for testing.
- ⚠️ Trade-off: Developers running tests locally must also ensure their DB runs on 5433 or override the `POSTGRES_PORT` environment variable.

## ADR-002: Progressive Credential Loading (PCL) Architecture
- **Context:** Production hardening required live backends (PostgreSQL, Redis, OpenAI, Anthropic), but removing mocks would break CI pipelines and create high developer onboarding friction.
- **Decision:** Implement Progressive Credential Loading. Keep in-memory and local mock heuristics as the default safe baseline, while wrapping external integrations in auto-promoting factory adapters triggered by environment variables.
- **Consequences:** 
  - *Pros:* 100% CI pass rate without requiring external secrets; zero setup friction for new contributors; progressive upgrade to production clusters.
  - *Cons:* Adds lightweight factory abstraction layers and runtime credential detection logic.
