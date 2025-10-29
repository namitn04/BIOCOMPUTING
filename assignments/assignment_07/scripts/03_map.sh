#!/bin/bash

set -ueo pipefail

# One can change these variables depending on their repo layout

SCR_DIR="${HOME}/scr10/assignment_07"

ROOT_DIR="${HOME}/BIOCOMPUTING/assignments/assignment_07"

OUT_DIR="${SCR_DIR}/data/output"

QC_DIR="${SCR_DIR}/data/clean"

SRA_TABLE="${ROOT_DIR}/data/SraRunTable.csv"

DOG_REF="${SCR_DIR}/data/dog_reference/ncbi_dataset/data/GCF_011100685.1/GCF_011100685.1_UU_Cfam_GSD_1.0_genomic.fna"


mkdir -p "${OUT_DIR}"

for RUN in $(cut -d',' -f1 "${SRA_TABLE}" | tail -n +2); do

    echo "Running bbmap on ${RUN}"

    bbmap.sh ref="${DOG_REF}" in1="${QC_DIR}/${RUN}_1.trimmed.fastq" in2="${QC_DIR}/${RUN}_2.trimmed.fastq" out="${OUT_DIR}/${RUN}_mapped_to_dog.sam" minid=0.95 -Xmx16g

done

rm -rf "${ROOT_DIR}/ref"

for SAMFILE in "${OUT_DIR}"/*_mapped_to_dog.sam; do

    BASENAME=$(basename "${SAMFILE}" .sam)

    MAPPED_OUT="${OUT_DIR}/${BASENAME}.matches.sam"

    samtools view -F 4 "${SAMFILE}" > "${MAPPED_OUT}"

done
