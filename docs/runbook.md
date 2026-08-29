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
