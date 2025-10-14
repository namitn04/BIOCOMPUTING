#!/bin/bash

set -ueo pipefail

mkdir -p assemblies/assembly_{module,module_build}

module load Flye/gcc-11.4.1/2.9.6 

flye --nano-hq data/SRR33939694.fastq --out-dir ./assemblies/assembly_module_build --threads 6 --meta

mv assemblies/assembly_module_build/assembly.fasta assemblies/assembly_module/module_assembly.fasta

mv assemblies/assembly_module_build/flye.log assemblies/assembly_module/module_flye.log

rm -rf assemblies/assembly_module_build/
