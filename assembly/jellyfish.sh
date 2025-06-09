#!/bin/bash
#SBATCH --job-name=jellyfish_M
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=600gb
#SBATCH --time=48:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=eab77806@uga.edu
#SBATCH --output=/scratch/eab77806/logs/jellyfish.%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/jellyfish.%x_%j.error

OUTDIR="/scratch/eab77806/jim_projects/ipomoea/jellyfish"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

SAMPLE_NAME='i_purpurea'
R01='../hifi/out.fastq.gz'
KMER_SIZE=41

ml Jellyfish/2.3.0-GCC-11.3.0

jellyfish count <(zcat $R01) -t $SLURM_CPUS_PER_TASK -m $KMER_SIZE -C -o $SAMPLE_NAME.$KMER_SIZE.jf --disk -s 4G
jellyfish histo $SAMPLE_NAME.$KMER_SIZE.jf -o $SAMPLE_NAME.$KMER_SIZE.hist