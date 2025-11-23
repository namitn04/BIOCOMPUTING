#!/bin/bash
#SBATCH --job-name=assignment_8
#SBATCH --output=/sciclone/home/ncnallapaneni/BIOCOMPUTING/assignments/assignment_08/output/%x.%j.out
#SBATCH --error=/sciclone/home/ncnallapaneni/BIOCOMPUTING/assignments/assignment_08/output/%x.%j.err
#SBATCH --time=2-00:00:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ncnallapaneni@wm.edu

set -euo pipefail

PROJECT_ROOT="${HOME}/BIOCOMPUTING/assignments/assignment_08"

cd "${PROJECT_ROOT}"

bash scripts/00_setup.sh

bash scripts/01_download.sh

bash scripts/02_qc.sh
