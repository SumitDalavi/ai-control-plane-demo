#!/usr/bin/env bash
set -euo pipefail

# Scenario: Trigger eval with "bad" prompt version -> regression detected
echo "--- Scenario 05: Regression Alert ---"

RESPONSE=$(curl --fail -s -X POST http://localhost:5001/v1/eval/trigger \
  -H "Content-Type: application/json" \
  -d '{"prompt_version": "v2-bad"}')

echo "$RESPONSE" | grep -q "regression_detected"
echo "✅ Success: Regression detected and alert logged."
