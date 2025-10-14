#!/bin/bash

set -ueo pipefail

mkdir -p data

cd data

wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz

gunzip SRR33939694.fastq.gz

