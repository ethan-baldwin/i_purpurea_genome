#!/bin/bash
#SBATCH --job-name=liftoff
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=50gb
#SBATCH --time=72:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.error

OUTDIR="/scratch/eab77806/jim_projects/ipomoea/annotation"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

ml Liftoff/1.6.3

GFF="/scratch/eab77806/jim_projects/ipomoea/previous_genome/Ipomoea_purpurea_annos1-cds0-id_typename-nu1-upa1-add_chr0.gid58735.gff"
REF="/scratch/eab77806/jim_projects/ipomoea/previous_genome/Ipomoea_purpurea.faa"
ASSEMBLY="/scratch/eab77806/jim_projects/ipomoea/fasta/yahs_final.FINAL.fa"
OUT_GFF="ipomoea_purpurea_liftoff.gff3"

liftoff -g $GFF \
    -o $OUT_GFF \
    -p $SLURM_CPUS_PER_TASK \
    -copies \
    $ASSEMBLY $REF

