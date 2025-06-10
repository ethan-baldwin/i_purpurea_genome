#!/bin/bash
#SBATCH --job-name=bwa_yahs
#SBATCH --partition=highmem_p
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=225gb
#SBATCH --time=48:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.error

OUTDIR="/scratch/eab77806/jim_projects/ipomoea/scaffolding"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

# path to assembly file
assembly='/scratch/eab77806/jim_projects/ipomoea/assembly_primary/hifiasm.p_ctg.fa'

# paths to omni-c reads
R1='/scratch/eab77806/jim_projects/ipomoea/hic/morning_glory_baucom_S3HiC_R1.fastq.gz'
R2='/scratch/eab77806/jim_projects/ipomoea/hic/morning_glory_baucom_S3HiC_R2.fastq.gz'

# load samtools
ml SAMtools/1.16.1-GCC-11.3.0

# load BWA
ml BWA/0.7.17-GCCcore-11.3.0
#BWA will create the .amb, .ann, .bwt, .pac, and .sa that are used in BWA
bwa index -a bwtsw $assembly

# map reads to new indexed references - hap1
bwa mem -5SP -t $SLURM_CPUS_PER_TASK $assembly $R1 $R2 | ~/samblaster/samblaster | samtools view -@ $SLURM_CPUS_PER_TASK -S -h -F 2316 - | samtools sort -@ 48 -m 3G -n -O BAM -o ${assembly}__hic_aligned_trimmed_dedupped.sorted.bam -
