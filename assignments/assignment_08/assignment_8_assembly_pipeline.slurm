#!/bin/bash
#SBATCH --job-name=assignment_8_assembly
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

# bash scripts/00_setup.sh

# bash scripts/01_download.sh

# bash scripts/02_qc.sh

sbatch scripts/ERR1912964_assemble.slurm

sbatch scripts/ERR1912976_assemble.slurm

sbatch scripts/ERR1913016_assemble.slurm

sbatch scripts/ERR1913044_assemble.slurm

sbatch scripts/ERR1913059_assemble.slurm

sbatch scripts/ERR1913060_assemble.slurm

sbatch scripts/ERR1913073_assemble.slurm

sbatch scripts/ERR1913108_assemble.slurm

sbatch scripts/ERR1913110_assemble.slurm

sbatch scripts/ERR1913119_assemble.slurm

# bash scripts/04_annotate.sh

# bash scripts/05_coverage.sh
