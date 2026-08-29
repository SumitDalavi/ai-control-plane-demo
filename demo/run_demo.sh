#!/usr/bin/env bash
set -euo pipefail

export DEMO_MODE="${DEMO_MODE:-stub}"

echo "=========================================="
echo "🚀 Running AI Control Plane Demo (Mode: $DEMO_MODE)"
echo "=========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# We use DEMO_MODE to pass into scenarios if they need logic branches.

echo "Running Scenarios..."
for script in "$SCRIPT_DIR"/scenarios/*.sh; do
  echo ""
  bash "$script"
done

echo ""
echo "✅ All scenarios passed."
