#!/bin/bash
# FORGE Phase 0 — Run all benchmarks and generate results
set -e

PHASE0_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$PHASE0_DIR/src"
RESULTS="$PHASE0_DIR/results"
ZIG=/usr/local/bin/zig

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         FORGE Framework — Phase 0 Benchmark Runner       ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "System: $(uname -m) | Cores: $(nproc) | RAM: $(free -h | awk '/Mem:/{print $2}')"
echo "Zig: $($ZIG version)"
echo ""

mkdir -p "$RESULTS"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULT_FILE="$RESULTS/benchmark_$TIMESTAMP.txt"

{
echo "FORGE Phase 0 Benchmark Results"
echo "Date: $(date)"
echo "System: $(uname -srm)"
echo "CPU cores: $(nproc)"
echo "RAM: $(free -h | awk '/Mem:/{print $2}')"
echo "Zig: $($ZIG version)"
echo "=================================="
echo ""
} > "$RESULT_FILE"

# Build and run each benchmark
for bench in stream_bench parallel_bench http_bench; do
    echo "━━━ Building $bench ━━━"
    $ZIG build-exe "$SRC/$bench.zig" \
        -O ReleaseFast \
        -o "$PHASE0_DIR/scripts/$bench" \
        2>&1

    echo "━━━ Running $bench ━━━"
    echo "" | tee -a "$RESULT_FILE"
    echo "=== $bench ===" >> "$RESULT_FILE"
    "$PHASE0_DIR/scripts/$bench" 2>&1 | tee -a "$RESULT_FILE"

    # Cleanup binary
    rm -f "$PHASE0_DIR/scripts/$bench"
    echo ""
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Results saved to: $RESULT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
