#!/bin/bash

set -ueo pipefail

module load miniforge3

export CONDA_PKGS_DIRS="$HOME/.conda/pkgs"

source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

mamba create -n flye-env -c conda-forge -c bioconda flye=2.9.6 -y
