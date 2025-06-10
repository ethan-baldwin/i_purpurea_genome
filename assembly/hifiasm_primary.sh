#!/bin/bash
#SBATCH --job-name=hifiasm
#SBATCH --partition=highmem_p
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=400gb
#SBATCH --time=150:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=eab77806@uga.edu
#SBATCH --output=/scratch/eab77806/logs/hifiasm.%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/hifiasm.%x_%j.error

OUTDIR="/scratch/eab77806/jim_projects/ipomoea"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

ml hifiasm/0.24.0-GCCcore-12.3.0

hifiasm -o hifiasm -t $SLURM_CPUS_PER_TASK --primary hifi/out.fastq.gz