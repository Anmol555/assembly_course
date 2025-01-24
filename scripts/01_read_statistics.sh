#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --mail-user=anmol.ratan@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/aratan/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/aratan/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pibu_el8

# Load the FastQC module
module load FastQC/0.11.9-Java-11

# Define the directories containing FASTQ files
ACCESSION_DIR="/data/courses/assembly-annotation-course/raw_data/No-0"
RNAseq_Sha_DIR="/data/courses/assembly-annotation-course/raw_data/RNAseq_Sha"

# Output directory for FastQC results
OUTPUT_DIR="/data/users/aratan/fastqcresults"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Run FastQC on all FASTQ files in the ACCESSION and RNAseq_Sha directories
for file in $ACCESSION_DIR/*.fastq.gz $RNAseq_Sha_DIR/*.fastq.gz
do
    fastqc -o $OUTPUT_DIR $file
done

