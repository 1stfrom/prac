#!/bin/sh
#SBATCH --ntasks-per-node=16
#SBATCH --nodes=1
#SBATCH --mem=64gb
#SBATCH --time=72:00:00
#SBATCH --job-name=trimmomatic
#SBATCH --mail-user=nathanchu@huskers.unl.edu
#SBATCH --mail-type=ALL
#SBATCH --error=/work/jyanglab/nathanma/prac/2023_SNP_prac/log/trimmomatic.err
#SBATCH --output=/work/jyanglab/nathanma/prac/2023_SNP_prac/log/trimmomatic.out

module load trimmomatic/0.39

# Define input and output directories
INDIR=/work/jyanglab/nathanma/prac/2023_SNP_prac/data
OUTDIR=/work/jyanglab/nathanma/prac/2023_SNP_prac/out/trim

# Adapter sequence file path
#ADAPTERS=/path/to/adapter_seq.fa  # Make sure this path is correct

# Create output directory if it doesn't exist
mkdir -p ${OUTDIR}

# Define Trimmomatic parameters
#ILLUMINACLIP="ILLUMINACLIP:${ADAPTERS}:2:30:10"
TRAILING="TRAILING:20"
SLIDINGWINDOW="SLIDINGWINDOW:4:20"
#HEADCROP="HEADCROP:8"

MINLEN="MINLEN:40"
#CROP="CROP:125"


# Call the Python script and read the output into the SAMPLES array
SAMPLES=($(python /work/jyanglab/nathanma/prac/2023_SNP_prac/script/find_samples2.py ${INDIR}))


# Check the SAMPLES array
echo "Detected SAMPLES:"
printf "%s\n" "${SAMPLES[@]}"

# Loop through each sample and process with Trimmomatic
for SAMPLE in "${SAMPLES[@]}"; do
    R1=${INDIR}/${SAMPLE}_1.fastq.gz
    R2=${INDIR}/${SAMPLE}_2.fastq.gz
    P1=${OUTDIR}/${SAMPLE}_1_paired_trimmed.fastq.gz
    U1=${OUTDIR}/${SAMPLE}_1_unpaired_trimmed.fastq.gz
    P2=${OUTDIR}/${SAMPLE}_2_paired_trimmed.fastq.gz
    U2=${OUTDIR}/${SAMPLE}_2_unpaired_trimmed.fastq.gz

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
    #${ILLUMINACLIP} \
    ${TRAILING} \
    ${SLIDINGWINDOW} \
    #${HEADCROP} \
    ${MINLEN} \
    #${CROP}
done

