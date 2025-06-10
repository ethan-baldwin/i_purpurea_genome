#!/bin/bash
#SBATCH --job-name=juicer
#SBATCH --partition=highmem_p
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=200gb
#SBATCH --time=120:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.error

OUTDIR="/scratch/eab77806/genome_assembly/scaffolding/hap1"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

ml YaHS/1.1-GCC-11.3.0

# name of assembly file
assembly='/scratch/eab77806/jim_projects/ipomoea/assembly_primary/hifiasm.p_ctg.fa'

(juicer pre yahs.out.bin yahs.out_scaffolds_final.agp $assembly.fai | sort -k2,2d -k6,6d -T ./ --parallel=16 -S32G | awk 'NF' > $asssembly.alignments_sorted.txt.part) && (mv $asssembly.alignments_sorted.txt.part $asssembly.alignments_sorted.txt)

ml Juicer/1.6-foss-2022a-CUDA-11.7.0

(java -jar -Xmx60G $EBROOTJUICER/juicer_tools.jar pre $asssembly.alignments_sorted.txt out.hic.part scaffolds_final_lengths.txt) && (mv out.hic.part out.hic)

# java -Xmx36G -jar $EBROOTJUICEBOX/juicer_tools.2.20.00.jar pre -x yahs_hap1_100kb.txt yahs_hap1_100kb.hic <(echo "assembly 1908126270")
# cat yahs_hap1_100kb_tmp_juicer_pre_JBAT.log  | grep PRE_C_SIZE | awk -v L=100000 '{if($3>=L) print $2" "$3}'

# (java -jar -Xmx200G /scratch/eab77806/juicer_tools.jar -x --threads 32 pre yahs_hap1_100kb.txt yahs_hap1_100kb.hic.part <(cat yahs_hap1_100kb_tmp_juicer_pre_JBAT.log  | grep PRE_C_SIZE | awk -v L=100000 '{if($3>=L) print $2" "$3}')) && (mv yahs_hap1_run2.hic.part yahs_hap1_run2.hic)

(java -jar -Xmx200G /home/eab77806/juicer_tools.1.9.9_jcuda.0.8.jar pre yahs.txt out.hic.part <(cat yahs_tmp_juicer_pre_JBAT.log  | grep PRE_C_SIZE | awk '{print $2" "$3}')) && (mv yahs_hap1_1.9.hic.part yahs_hap1_1.9.hic)
