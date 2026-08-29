#!/usr/bin/env bash
set -euo pipefail

# Scenario: Cost routing based on prompt complexity
echo "--- Scenario 04: Cost Routing ---"

echo "Testing simple prompt routing..."
curl --fail -s -X POST http://localhost:3002/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Say hello"}]}' | grep -q "claude-haiku-20240307"
echo "✅ Routed to claude-haiku-20240307"

echo "Testing complex prompt routing..."
curl --fail -s -X POST http://localhost:3002/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Please analyze and compare this step-by-step and generate a judgment."}]}' | grep -q "gpt-4o"
echo "✅ Routed to gpt-4o"
