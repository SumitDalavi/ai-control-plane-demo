#!/usr/bin/env bash
set -euo pipefail

# Scenario: Cost routing based on prompt complexity
echo "--- Scenario 04: Cost Routing ---"

echo "Testing simple prompt routing..."
curl --fail -s -X POST http://localhost:3002/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Say hello"}' | grep -q "gpt-4o-mini"
echo "✅ Routed to gpt-4o-mini"

echo "Testing complex prompt routing..."
curl --fail -s -X POST http://localhost:3002/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Write a complex react application from scratch"}' | grep -q "gpt-4o"
echo "✅ Routed to gpt-4o"
