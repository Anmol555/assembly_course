#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --job-name=fastp_illumina
#SBATCH --output=/data/users/aratan/assembly_annotation_course/output_fastp_illumina_%j.o
#SBATCH --error=/data/users/aratan/assembly_annotation_course/error_fastp_illumina_%j.e
#SBATCH --partition=pibu_el8

# Load fastp module
module load fastp/0.23.4-GCC-10.3.0

# Define the directories containing FASTQ files for Illumina RNAseq
ILLUMINA_DIR="/data/users/aratan/assembly_annotation_course/RNAseq_Sha"
PACBIO_DIR="/data/users/aratan/assembly_annotation_course/No-0"

# Output directory for filtered reads
OUTPUT_DIR="/data/users/aratan/assembly_annotation_course/fastp_filtered"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Run fastp on all FASTQ files in the ILLUMINA_DIR to filter and trim reads
for file in $ILLUMINA_DIR/*.fastq.gz
do
    fastp -i $file -o $OUTPUT_DIR/$(basename ${file%.fastq.gz})_filtered.fastq.gz \
    -h $OUTPUT_DIR/$(basename ${file%.fastq.gz})_fastp_report.html \
    -j $OUTPUT_DIR/$(basename ${file%.fastq.gz})_fastp_report.json \
    -q 20 -l 30
done





# Run fastp without filtering on all PacBio HiFi data to get total number of bases
for file in $PACBIO_DIR/*.fastq.gz
do
    fastp -i $file -o $OUTPUT_DIR/$(basename ${file%.fastq.gz})_processed.fastq.gz \
    -h $OUTPUT_DIR/$(basename ${file%.fastq.gz})_fastp_report.html \
    -j $OUTPUT_DIR/$(basename ${file%.fastq.gz})_fastp_report.json \
    --disable_quality_filtering --disable_length_filtering
done
