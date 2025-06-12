#!/bin/bash
#SBATCH --job-name=busco
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=50gb
#SBATCH --time=024:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.error

OUTDIR="/scratch/eab77806/jim_projects/ipomoea/busco"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

# load busco
ml BUSCO

GENOME="/scratch/eab77806/jim_projects/ipomoea/fasta/"
PEPTIDE="/scratch/eab77806/jim_projects/ipomoea/annotation/i_purpurea.fa.peptides.nofilter.fasta"

# run busco for protein annotation completeness assessment using the lineage dataset embryophyta_odb10
busco -m protein -i $PEPTIDE -l eudicots_odb10 -o i_purpurea_annotation.prot.eud.BUSCO.out -c $SLURM_CPUS_PER_TASK

# run busco in genome mode
busco -m genome -i $GENOME -l eudicots_odb10 -o i_purpurea_annotation.genome.eud.BUSCO.out -c $SLURM_CPUS_PER_TASK -f