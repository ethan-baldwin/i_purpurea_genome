#!/bin/bash
#SBATCH --job-name=orthofinder
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50gb
#SBATCH --time=48:00:00
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
ml OrthoFinder/2.5.4-foss-2022a

# run orthofinder
orthofinder -f ./tmp -t 16 -a 1 -X -o ./orthofinder 