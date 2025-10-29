# Assignment 07 – Namit Nallapaneni, 10/29/25

## Task 1

mkdir -p data output scripts

---

I worked mostly out of /scr10/assignment_07 for so I could store the data without worry.

I later decided to only save a final output table to ~/BIOCOMPUTING/assignments/assignment_07/output/. Everything else (raw, clean, reference, etc.) was handled in scr10.

---

### Software setup

Had fasterq-dump and datasets already from class.

Installed samtools manually:

tar -xvjf samtools-1.22.1.tar.bz2

cd samtools-1.22.1/

./configure --prefix=/sciclone/home/ncnallapaneni/programs

make

make install

export PATH=$PATH:/sciclone/home/ncnallapaneni/programs/bin

---

## Task 2

Search term used:

dental plaque[All Fields] AND "human oral metagenome"[Organism] AND ("biomol dna"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "filetype fastq"[Properties])

---

I filtered in the Run Selector using:

Bytes: 0-5 GB

LibrarySelection: RANDOM

Used first 10 samples above 100 MB

---

SRA metadata uploaded with:

sftp ncnallapaneni@bora.sciclone.wm.edu

sftp> lcd /Users/namitnallapaneni/Desktop/junk

sftp> cd BIOCOMPUTING/assignments/assignment_07/data/

sftp> put SraRunTable.csv

sftp> quit

---

### Script

Loops through first column of CSV

Uses fasterq-dump to download reads to ${SCR_DIR}/data/raw

Downloads dog reference genome (GCF_011100685.1) with datasets

Unzips into ${SCR_DIR}/data/dog_reference

01_download.sh:

#!/bin/bash

set -ueo pipefail

#One can change these variables depending on their repo layout

SCR_DIR="${HOME}/scr10/assignment_07"

ROOT_DIR="${HOME}/BIOCOMPUTING/assignments/assignment_07"

SRA_TABLE="${ROOT_DIR}/data/SraRunTable.csv"

RAW_DIR="${SCR_DIR}/data/raw"

DOG_REF_DIR="${SCR_DIR}/data/dog_reference"

DOG_REF_ACC="GCF_011100685.1"

#make sure output dirs exist

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

---

## Task 3

### Script

Trimmed and filtered reads with:

--trim_front1 8 --trim_front2 8

--trim_tail1 20 --trim_tail2 20

--n_base_limit 0 --length_required 100

--average_qual 20

Outputs saved to ${SCR_DIR}/data/clean/

02_cleanup.sh:

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

---

## Task 4 + 5

### Script

Mapped reads with bbmap.sh:

ref=${DOG_REF}

minid=0.95

-Xmx16g

Extracted mapped reads with:

samtools view -F 4

Clean .sam --> .matches.sam

Removed indexing files to save space.

---

## Task 6

Ran everything through SLURM the whole time (not just at step 6).

Was testing scripts as I added each task with sbatch.

---

#!/bin/bash

#SBATCH --job-name=assignment_7

#SBATCH --output=/sciclone/home/ncnallapaneni/BIOCOMPUTING/assignments/assignment_07/output/%x.%j.out

#SBATCH --error=/sciclone/home/ncnallapaneni/BIOCOMPUTING/assignments/assignment_07/output/%x.%j.err

#SBATCH --time=2-00:00:00

#SBATCH --cpus-per-task=20

#SBATCH --mem=20G

#SBATCH --mail-type=END,FAIL

#SBATCH --mail-user=ncnallapaneni@wm.edu

set -euo pipefail

PROJECT_ROOT="${HOME}/BIOCOMPUTING/assignments/assignment_07"

cd "${PROJECT_ROOT}"

bash scripts/01_download.sh

bash scripts/02_cleanup.sh

bash scripts/03_map.sh

bash scripts/04_stats.sh

---

## Task 7 + 8

Counts reads and mapped reads per sample:

---

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

---


