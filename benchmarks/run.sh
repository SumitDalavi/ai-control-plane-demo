#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR/.."

echo "Starting infrastructure and services for benchmark..."
make up
make wait

echo "Running benchmark script..."
python3 benchmarks/benchmark.py

echo "Tearing down..."
make down
