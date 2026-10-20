# Changelog

## [0.2.0] - 2026-10-20
### Added
- **Progressive Credential Loading (PCL):** Dynamic auto-promotion between zero-dependency mock fallbacks and live production backends based on environment credentials.
- **Dual Distribution:** Universal OCI container publishing to GitHub Container Registry (`ghcr.io/sumitdalavi/ai-control-plane-demo`) and Helm OCI registries alongside GitHub Release tarballs.
- **Health Reporting:** Exposed `/health` or `/healthz` endpoint with PCL status detection (`mock` vs `live`).
- **Dynamic Reloading:** Support for atomic ConfigMap / secret reloads without requiring pod restarts.
- **Supply Chain Security:** Trivy vulnerability scan gates and SPDX JSON SBOM (`sbom.spdx.json`) generation for all releases.

## [0.1.0] - 2026-10-18
### Added
- Initial baseline service implementation, unit test suites, and CI workflows.

## [2026-08-29] - Initial Setup and CI Fixes
### Added
- Created the repository.
- Added GitHub Actions CI pipeline (`.github/workflows/ci.yml`).
- Added standard documentation (`changelog.md`, `runbook.md`, `decisions.md`).

### Fixed
- Fixed PostgreSQL service container in CI mapping to port `5433` to prevent conflicts with the GitHub runner's default Postgres instance on port 5432.
- Added a `psql` schema initialization step in CI before running Jest tests to resolve `relation does not exist` errors.

## [v5.0.0] - 2026-08-30
### Added
- Upgraded to Portfolio V5 standards (World-Class).
- Added verifiable, reproducible E2E integration tests captured in run-history.
- Refined README.md presentation and architectural documentation.

### Fixed (Post-Release)
- Fixed CI benchmark step to gracefully handle missing dependencies in isolated repository checkouts.


---

## [v0.1.0] — 2026-10-20
### Added
- **Release Automation:** Added `.github/workflows/release.yml` with automated catalog validation, tarball packaging, and SPDX SBOM generation.
- **Supply Chain Security:** Generated Anchore Syft SPDX JSON SBOM and cryptographic SHA-256 checksums.
- **Release Verification:** Added release verification documentation, badges, and operational runbook.
