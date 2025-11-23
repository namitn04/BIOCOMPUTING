#!/bin/bash
#SBATCH --job-name=ERR1913073_Assembly
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=FAIL,BEGIN,END
#SBATCH --mail-user=ncnallapaneni@wm.edu
#SBATCH --output=/sciclone/home/ncnallapaneni/BIOCOMPUTING/assignments/assignment_08/output/%x.%j.out
#SBATCH --error=/sciclone/home/ncnallapaneni/BIOCOMPUTING/assignments/assignment_08/output/%x.%j.err

# set filepath vars
SCR_DIR="${HOME}/scr10/assignment_08" # change to main writeable scratch space if not on W&M HPC
PROJECT_DIR="${SCR_DIR}/mg_assembly_08"
DB_DIR="${SCR_DIR}/db"
DL_DIR="${PROJECT_DIR}/data/raw"
SRA_DIR="${SCR_DIR}/SRA"
CONTIG_DIR="${PROJECT_DIR}/contigs"
mkdir -p $CONTIG_DIR
for fwd in ${DL_DIR}/*ERR1913073*1_qc.fastq.gz
do
# derive input and output variables
rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
filename=$(basename $fwd)
samplename=$(echo ${filename%%_*})
outdir=$(echo ${CONTIG_DIR}/${samplename})
# run spades with mostly default options
spades.py -1 $fwd -2 $rev -o $outdir -t 20 --meta
done
