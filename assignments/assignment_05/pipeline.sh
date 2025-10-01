#!/bin/bash

set -ueo pipefail

MAIN=${HOME}/BIOCOMPUTING/assignments/assignment_05

cd ${MAIN}

echo "run script 01"

./scripts/01_download_data.sh

echo "run script 02"

for i in ./data/raw/*R1*; do ./scripts/02_run_fastp.sh $i; done

echo "sucess!"
