#!/bin/bash

set -ueo pipefail

MAIN=${HOME}/BIOCOMPUTING/assignments/assignment_05

cd ${MAIN}

cd data/raw/

wget https://gzahn.github.io/data/fastq_examples.tar

tar -xf fastq_examples.tar

rm fastq_examples.tar

