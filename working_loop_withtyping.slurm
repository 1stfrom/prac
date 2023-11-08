#!/bin/sh
#SBATCH --ntasks-per-node=16
#SBATCH --nodes=1
#SBATCH --mem=64gb
#SBATCH --time=72:00:00
#SBATCH --job-name=trimmomatic
#SBATCH --mail-user=nathanchu@huskers.unl.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/work/agrobinf/shared/agrobinf2023/users/nathanma/log/trimmomatic.err
#SBATCH --output=/work/agrobinf/shared/agrobinf2023/users/nathanma/log/trimmomatic.out

module load trimmomatic/0.39

# Define input and output directories
INDIR=/work/agrobinf/shared/agrobinf2023/data/bent/raw
OUTDIR=/work/agrobinf/shared/agrobinf2023/users/nathanma/out/bent/trim_bent

# Adapter sequence file path
ADAPTERS=/work/agrobinf/shared/agrobinf2023/data/bent/contaminants.fa

# Define Trimmomatic parameters
ILLUMINACLIP="ILLUMINACLIP:${ADAPTERS}:2:30:10"
SLIDINGWINDOW="SLIDINGWINDOW:4:32"
HEADCROP="HEADCROP:8"
MINLEN="MINLEN:126"
CROP="CROP:125"

# Array of sample prefixes
declare -a SAMPLES=("R301-10_S49" "R301-11_S51" "R301-12_S53" "R301-7_S59" "R301-8_S61" "R301-9_S46")

# Loop through each sample and process with Trimmomatic
for SAMPLE in "${SAMPLES[@]}"; do
    R1=${INDIR}/${SAMPLE}_L002_R1_001.fastq.gz
    R2=${INDIR}/${SAMPLE}_L002_R2_001.fastq.gz
    P1=${OUTDIR}/${SAMPLE}_R1_paired_trimmed.fastq.gz
    U1=${OUTDIR}/${SAMPLE}_R1_unpaired_trimmed.fastq.gz
    P2=${OUTDIR}/${SAMPLE}_R2_paired_trimmed.fastq.gz
    U2=${OUTDIR}/${SAMPLE}_R2_unpaired_trimmed.fastq.gz
    
    # Run Trimmomatic
    trimmomatic PE \
    -threads 8 \
    -phred33 \
    ${R1} \
    ${R2} \
    ${P1} \
    ${U1} \
    ${P2} \
    ${U2} \
    ${ILLUMINACLIP} \
    ${SLIDINGWINDOW} \
    ${HEADCROP} \
    ${MINLEN} \
    ${CROP}
done