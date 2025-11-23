#!/bin/bash
#SBATCH --job-name=MG_Annotate
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --time=2-00:00:00
#SBATCH --mem=64G
#SBATCH --mail-type=FAIL,END
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
ANNOT_DIR="${PROJECT_DIR}/annotations"

# load prokka
module load miniforge3
eval "$(conda shell.bash hook)"
conda activate prokka-env


for fwd in ${DL_DIR}/*1_qc.fastq.gz
do

# derive input and output variables
rev=${fwd/_1_qc.fastq.gz/_2_qc.fastq.gz}
filename=$(basename $fwd)
samplename=$(echo ${filename%%_*})
contigs=$(echo ${CONTIG_DIR}/${samplename}/contigs.fasta)
outdir=$(echo ${ANNOT_DIR}/${samplename})
contigs_safe=${contigs/.fasta/.safe.fasta}

# rename fasta headers to account for potentially too-long names (or spaces)
seqtk rename <(cat $contigs | sed 's/ //g') contig_ > $contigs_safe

# run prokka to predict and annotate genes
prokka $contigs_safe --outdir $outdir --prefix $samplename --cpus 20 --kingdom Bacteria --metagenome --locustag $samplename --force --evalue 1e-9

done

conda deactivate && conda deactivate
