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

ml YaHS/1.2.2-GCC-11.3.0

# path to assembly file
assembly='/scratch/eab77806/jim_projects/ipomoea/assembly_primary/hifiasm.p_ctg.fa'
prefix='yahs_no_ec'

yahs $assembly ${assembly}__hic_aligned_trimmed_dedupped.sorted.bam -o $prefix --no-contig-ec

# ml SeqKit/2.5.1


# seqkit seq yahs.out_scaffolds_final.fa -m 100000 > yahs.out_scaffolds_final_100kb.fa


# load samtools
ml SAMtools/1.16.1-GCC-11.3.0
## prepare chromosome size file from samtools index file
samtools faidx ${prefix}_scaffolds_final.fa

#### this is to generate input file for juicer_tools - assembly (JBAT) mode (-a)
juicer pre -a -o $prefix $prefix.bin ${prefix}_scaffolds_final.agp $assembly.fai >${prefix}_tmp_juicer_pre_JBAT.log 2>&1

ml Juicer/1.6-foss-2022a-CUDA-11.7.0

java -Xmx150G -jar /home/eab77806/juicer_tools.1.9.9_jcuda.0.8.jar pre $prefix.txt $prefix.hic <(cat ${prefix}_tmp_juicer_pre_JBAT.log  | grep PRE_C_SIZE | awk '{print $2" "$3}')
