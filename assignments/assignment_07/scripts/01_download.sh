#!/bin/bash

set -ueo pipefail

# One can change these variables depending on their repo layout

SCR_DIR="${HOME}/scr10/assignment_07"

ROOT_DIR="${HOME}/BIOCOMPUTING/assignments/assignment_07"

SRA_TABLE="${ROOT_DIR}/data/SraRunTable.csv"

RAW_DIR="${SCR_DIR}/data/raw"

DOG_REF_DIR="${SCR_DIR}/data/dog_reference"

DOG_REF_ACC="GCF_011100685.1"

# make sure output dirs exist

mkdir -p "${RAW_DIR}"
mkdir -p "${DOG_REF_DIR}"
mkdir -p "${ROOT_DIR}"


cd "${ROOT_DIR}"

cut -d',' -f1 "${SRA_TABLE}" | tail -n +2 | while read -r RUN; do

    echo "Downloading ${RUN}"

    fasterq-dump "${RUN}" --outdir "${RAW_DIR}"

done

echo "SRA download done."

echo "Downloading dog genome."

datasets download genome accession "${DOG_REF_ACC}" --include genome --filename "${DOG_REF_DIR}/${DOG_REF_ACC}.zip"

unzip -o "${DOG_REF_DIR}/${DOG_REF_ACC}.zip" -d "${DOG_REF_DIR}"

echo "Dog download done."
