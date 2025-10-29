## Task 1

mkdir -p data output scripts

## Task 2

dental plaque[All Fields] AND "human oral metagenome"[Organism] AND ("biomol dna"[Properties] AND "library layout paired"[Properties] AND "platform illumina"[Properties] AND "filetype fastq"[Properties])

Bytes -- 0-5GB

LibrarySelection -- RANDOM

I used the first 10 files above 100mb.

---

sftp ncnallapaneni@bora.sciclone.wm.edu

sftp> lcd /Users/namitnallapaneni/Desktop/junk
sftp> ls   	
sftp> cd BIOCOMPUTING/assignments/assignment_07/data/
sftp> put SraRunTable.csv
sftp> ls
sftp> quit


## Random Task - make sure i have all the softwares

I already had fasterq-dump and datasets downloaded and setup from class.



had to sftp samtools tar ball I downloaded on to my local, pretty much same way I got the run table.

tar -xvjf samtools-1.22.1.tar.bz2

rm samtools-1.22.1.tar.bz2

cd samtools-1.22.1/

./configure --prefix=/sciclone/home/ncnallapaneni/programs

make

make install

# Sam tools path
export PATH=$PATH:/sciclone/home/ncnallapaneni/programs/bin

---

## Task 2 cont.

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

---

## Task 3

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


## Task 4 + 5

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

## Task 7 + 8

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
