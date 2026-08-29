#!/usr/bin/env bash
set -euo pipefail

echo "Verifying postconditions..."
OUTPUT_DIR="demo_outputs_$(date +%s)"
mkdir -p "$OUTPUT_DIR"

# Example verification: Check if metrics are exported
curl --fail -s http://localhost:9091/metrics > "$OUTPUT_DIR/prometheus_metrics.txt"
if grep -q 'go_memstats' "$OUTPUT_DIR/prometheus_metrics.txt"; then
  echo "✅ Prometheus metrics collected successfully."
else
  echo "❌ Failed to find expected Prometheus metrics."
  exit 1
fi

echo "Verification complete. Artifacts saved in $OUTPUT_DIR."
