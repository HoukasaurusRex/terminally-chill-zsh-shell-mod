#!/bin/sh
# Benchmark ZSH startup time. Fails if average exceeds threshold.

RUNS="${STARTUP_TIME_RUNS:-5}"
THRESHOLD_MS="${STARTUP_TIME_THRESHOLD:-500}"

total=0
min=""
max=""

for i in $(seq 1 "$RUNS"); do
  start=$(date +%s%N 2>/dev/null)
  # Fallback for macOS (no %N support): use perl for millisecond precision
  if [ "$start" = "%N" ] || [ -z "$start" ]; then
    start=$(perl -MTime::HiRes=time -e 'printf "%.0f\n", time * 1000')
    zsh -i -c exit 2>/dev/null
    end=$(perl -MTime::HiRes=time -e 'printf "%.0f\n", time * 1000')
    ms=$((end - start))
  else
    zsh -i -c exit 2>/dev/null
    end=$(date +%s%N)
    ms=$(( (end - start) / 1000000 ))
  fi

  total=$((total + ms))

  if [ -z "$min" ] || [ "$ms" -lt "$min" ]; then
    min=$ms
  fi
  if [ -z "$max" ] || [ "$ms" -gt "$max" ]; then
    max=$ms
  fi

  printf "  Run %d: %dms\n" "$i" "$ms"
done

avg=$((total / RUNS))

printf "\nStartup time (%d runs): min=%dms avg=%dms max=%dms\n" "$RUNS" "$min" "$avg" "$max"

if [ "$avg" -gt "$THRESHOLD_MS" ]; then
  printf "FAIL: Average %dms exceeds threshold of %dms\n" "$avg" "$THRESHOLD_MS"
  exit 1
else
  printf "PASS: Average %dms is within threshold of %dms\n" "$avg" "$THRESHOLD_MS"
fi
