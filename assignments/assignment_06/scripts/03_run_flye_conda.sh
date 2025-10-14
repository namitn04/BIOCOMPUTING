#!/bin/bash

set -ueo pipefail

mkdir -p assemblies/assembly_{conda,conda_build}

module load miniforge3

source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"

conda activate flye-env

conda env export --no-builds > flye-env.yml

flye --nano-hq data/SRR33939694.fastq --out-dir ./assemblies/assembly_conda_build --threads 6 --meta

conda deactivate

mv assemblies/assembly_conda_build/assembly.fasta assemblies/assembly_conda/conda_assembly.fasta

mv assemblies/assembly_conda_build/flye.log assemblies/assembly_conda/conda_flye.log

rm -rf assemblies/assembly_conda_build/
