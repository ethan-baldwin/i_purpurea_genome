#!/bin/bash
#SBATCH --job-name=genespace
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=30gb
#SBATCH --time=8:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=eab77806@uga.edu
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.err

OUTDIR="/scratch/eab77806/jim_projects/ipomoea/genespace"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

# load orthofinder
ml R

# run orthofinder
Rscript ~/i_purpurea_genome/genespace/genespace.R