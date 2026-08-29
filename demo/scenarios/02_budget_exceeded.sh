#!/bin/bash
# Scenario: Team budget exhausted -> 429
echo "--- Scenario 02: Budget Exceeded ---"

# Simulate budget exceeded for a specific test token
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:4003/v1/chat/completions \
  -H "Authorization: Bearer test-team-exhausted-key" \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Hello"}]}')

if [ "$RESPONSE" -eq 429 ]; then
    echo "✅ Success: Gateway correctly returned 429 for exceeded team budget."
else
    echo "❌ Failed: Expected 429, got $RESPONSE"
fi
