#!/bin/bash

set -ueo pipefail

mkdir -p assemblies/assembly_{local,local_build}

flye --nano-hq data/SRR33939694.fastq --out-dir ./assemblies/assembly_local_build --threads 6 --meta

mv assemblies/assembly_local_build/assembly.fasta assemblies/assembly_local/local_assembly.fasta

mv assemblies/assembly_local_build/flye.log assemblies/assembly_local/local_flye.log

rm -rf assemblies/assembly_local_build/
