#!/bin/bash
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --job-name=best_K
#SBATCH --mail-user=anmol.ratan@students.unibe.ch
#SBATCH --mail-type=END
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/aratan/assembly_annotation_course/assembly_eval/mercury/%x/output_%j.o
#SBATCH --error=/data/users/aratan/assembly_annotation_course/assembly_eval/mercury/%x/error_%j.e

WORKDIR=/data/users/aratan/assembly_annotation_course/mercury/best_K/
cd $WORKDIR

# Check if required arguments are provided
if [ $# -lt 1 ]; then
  echo "Usage: ./best_k.sh [-c] <genome_size> [tolerable_collision_rate]"
  echo -e "  -c         : [OPTIONAL] evaluation will be on homopolymer compressed genome. EXPERIMENTAL"
  echo -e "  genome_size: Haploid genome size or diploid genome size, depending on what we evaluate. In bp."
  echo -e "  tolerable_collision_rate: [OPTIONAL] Error rate in the read set. DEFAULT=0.001 for illumina WGS"
  echo -e "See Fofanov et al. Bioinformatics, 2004 for more details."
  echo
  exit 1
fi

# Handle optional homopolymer compression flag
if [ "$1" = "-c" ]; then
  compress="1"
  shift
fi

# Get the tolerable collision rate or set default
if [ ! -z "$2" ]; then
  e=$2
else
  e=0.001
fi

# Set genome size
g=$1

echo "genome: $g"
echo "tolerable collision rate: $e"

# Set n based on compression
if [[ -z $compress ]]; then
  n=4
else
  n=3
fi

# Calculate k
k=$(echo $g $e | awk '{print $1"\t"(1-$2)/$2}' | awk -v n=$n '{print log($1*$2)/log(n)}')
echo "Calculated k: $k"

