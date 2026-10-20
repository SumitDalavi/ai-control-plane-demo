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
