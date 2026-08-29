# Changelog

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

