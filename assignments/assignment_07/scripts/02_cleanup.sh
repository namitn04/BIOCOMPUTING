#!/bin/bash

set -ueo pipefail

# One can change these variables depending on their repo layout

SCR_DIR="${HOME}/scr10/assignment_07"

ROOT_DIR="${HOME}/BIOCOMPUTING/assignments/assignment_07"

RAW_DIR="${SCR_DIR}/data/raw"

QC_DIR="${SCR_DIR}/data/clean"

SRA_TABLE="${ROOT_DIR}/data/SraRunTable.csv"

mkdir -p "${QC_DIR}"

for RUN in $(cut -d',' -f1 "${SRA_TABLE}" | tail -n +2); do

    echo "Running fastp on ${RUN}"

    fastp -i "${RAW_DIR}/${RUN}_1.fastq" -I "${RAW_DIR}/${RUN}_2.fastq" -o "${QC_DIR}/${RUN}_1.trimmed.fastq" -O "${QC_DIR}/${RUN}_2.trimmed.fastq" --thread 64 --trim_front1 8 --trim_front2 8 --trim_tail1 20 --trim_tail2 20 --n_base_limit 0 --length_required 100 --average_qual 20 --json /dev/null --html /dev/null

done
