#!/bin/bash

# Find project root and coverage folder
PROJ_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COV_DIR="${PROJ_DIR}/output/coverage"

cd "$COV_DIR" || exit 1

# Metadata
FASTP="fastp-l100-e10"
PROKKA="prokka-eval1e9"

# Sample groups
P_SAMPLES="ERR1912976 ERR1913073 ERR1913059 ERR1912964 ERR1913119"
C_SAMPLES="ERR1913016 ERR1913108 ERR1913060 ERR1913044 ERR1913110"

# Parkinson’s
for S in $P_SAMPLES; do
    for F in ${S}*; do
        [ -f "$F" ] || continue
        mv "$F" "${S}_p_${FASTP}_${PROKKA}${F#$S}"
    done
done

# Controls
for S in $C_SAMPLES; do
    for F in ${S}*; do
        [ -f "$F" ] || continue
        mv "$F" "${S}_c_${FASTP}_${PROKKA}${F#$S}"
    done
done

echo "Renaming complete."
