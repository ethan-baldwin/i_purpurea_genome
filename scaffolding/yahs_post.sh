#!/bin/bash
#SBATCH --job-name=yahs
#SBATCH --partition=highmem_p
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=100gb
#SBATCH --time=16:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.error

OUTDIR="/scratch/eab77806/jim_projects/ipomoea/scaffolding"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

ml YaHS/1.1-GCC-11.3.0

assembly='/scratch/eab77806/jim_projects/ipomoea/assembly_primary/hifiasm.p_ctg.fa'

juicer post -o yahs_final yahs.review.assembly yahs.liftover.agp $assembly