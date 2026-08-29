#!/usr/bin/env bash
set -euo pipefail

# Scenario: Cache hit -> same prompt twice
echo "--- Scenario 03: Semantic Cache Hit ---"

PROMPT="What is the capital of France?"

echo "Sending first request (Expect Cache Miss)..."
curl --fail -s -D headers_miss.txt -o /dev/null -X POST http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "{\"messages\": [{\"role\": \"user\", \"content\": \"$PROMPT\"}]}"
grep -q "X-Cache-Hit" headers_miss.txt && (echo "Error: Expected miss but got hit" && exit 1) || true

echo "Sending second request (Expect Cache Hit)..."
curl --fail -s -D headers_hit.txt -o /dev/null -X POST http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d "{\"messages\": [{\"role\": \"user\", \"content\": \"$PROMPT\"}]}"
grep -q "X-Cache-Hit" headers_hit.txt

echo "✅ Success: Cached request served."
