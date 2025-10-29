#!/bin/bash

set -ueo pipefail

# One can change these variables depending on their repo layout

SCR_DIR="${HOME}/scr10/assignment_07"

ROOT_DIR="${HOME}/BIOCOMPUTING/assignments/assignment_07"

OUT_DIR="${SCR_DIR}/data/output"

QC_DIR="${SCR_DIR}/data/clean"

mkdir -p "${ROOT_DIR}/output"

echo -e "Sample_ID\tn_Total_Reads\tn_Doggy_Reads" > "${ROOT_DIR}/output/stats.txt"

for SAMFILE in "${OUT_DIR}"/*_mapped_to_dog.matches.sam; do

    SAMPLE=$(basename "${SAMFILE}" _mapped_to_dog.matches.sam)

    R1_FASTQ="${QC_DIR}/${SAMPLE}_1.trimmed.fastq"

    N_QC_READS=$(($(wc -l < "${R1_FASTQ}") / 4))

    N_MAPPED_DOG=$(cut -f1 "${SAMFILE}" | sort | uniq | wc -l)

    echo -e "${SAMPLE}\t${N_QC_READS}\t${N_MAPPED_DOG}" >> "${ROOT_DIR}/output/stats.txt"

done






