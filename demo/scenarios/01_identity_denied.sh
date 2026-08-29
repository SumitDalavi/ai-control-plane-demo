#!/bin/bash
# Scenario: Valid identity -> authorized request, but with invalid token to see denial
echo "--- Scenario 01: Identity Denied ---"

# Assuming llm-gateway runs on port 4003
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:4003/v1/chat/completions \
  -H "Authorization: Bearer invalid-token" \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Hello"}]}')

if [ "$RESPONSE" -eq 401 ]; then
    echo "✅ Success: Gateway correctly returned 401 Unauthorized for invalid token."
else
    echo "❌ Failed: Expected 401, got $RESPONSE"
fi
