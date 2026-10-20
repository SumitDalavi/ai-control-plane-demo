# Runbook

## Running the Demo locally

1. Ensure you have Docker installed and running.
2. Ensure you have `nhi-agent-access-governance` database scripts available.
3. Start the PostgreSQL test database:
   ```bash
   docker run --name pg-test -e POSTGRES_PASSWORD=password -p 5433:5432 -d postgres:15
   ```
4. Initialize the schema:
   ```bash
   PGPASSWORD=password psql -h localhost -p 5433 -U postgres -d postgres -f ../nhi-agent-access-governance/scripts/init.sql
   ```
5. Install dependencies and run tests:
   ```bash
   npm install
   npm test
   ```


---

## Release Runbook

### Release Trigger
Tag push matching `v*.*.*` (e.g., `v0.1.0`).

### Automated Pipeline Stages
1. **Quality & Validation Gate:** Validates policy syntax, manifest schemas, and configuration integrity.
2. **Distribution Packaging:** Bundles clean production manifests into `ai-control-plane-demo-<tag>.tar.gz` and calculates SHA256 checksums.
3. **Syft Source SBOM:** Generates `sbom.spdx.json` adhering to SPDX 2.3 standard.
4. **GitHub Release:** Publishes release assets and release notes.

### Verification
```bash
gh release view v0.1.0 --repo SumitDalavi/ai-control-plane-demo
gh release download v0.1.0 --repo SumitDalavi/ai-control-plane-demo --pattern "checksums.txt"
```

### Failure Modes & Remediation
- **Linter / Test Failure:** Inspect policy syntax, configurations, or module arguments locally before tagging.
- **Checksum Mismatch:** Ensure file was completely downloaded without network truncation.

## Operations & Diagnostics Guide (v0.2.0)

### Mode Verification & Diagnostics
Inspect the active execution mode and backing provider status via the health endpoint:
```bash
# Check runtime mode and adapter status
curl -s http://localhost:8080/health | jq .
# Expected output when running without keys:
# {"status": "ok", "mode": {"database": "mock", "ai": "mock", "cache": "mock"}}
```

### Running in Mock Mode (Tier 1)
Start the service with zero external dependencies:
```bash
cp .env.example .env
# Start service without modifying .env
npm start || python main.py || go run .
```

### Running with Live Credentials (Tier 2 / 3)
Populate target credentials in `.env` and restart:
```bash
# Verify live upgrade via health check
curl -s http://localhost:8080/health | jq .mode
```

### Pulling Pre-Built OCI Image
```bash
docker pull ghcr.io/sumitdalavi/ai-control-plane-demo:v0.2.0
docker run -d -p 8080:8080 --env-file .env ghcr.io/sumitdalavi/ai-control-plane-demo:v0.2.0
```
