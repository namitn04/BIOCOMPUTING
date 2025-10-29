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
