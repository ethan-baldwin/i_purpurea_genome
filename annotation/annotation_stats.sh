#!/bin/bash
#SBATCH --job-name=annotation_stats
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20gb
#SBATCH --time=12:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/scratch/eab77806/logs/%x_%j.out
#SBATCH --error=/scratch/eab77806/logs/%x_%j.error

OUTDIR="/scratch/eab77806/jim_projects/ipomoea/annotation"
if [ ! -d $OUTDIR ]
then
    mkdir -p $OUTDIR
fi
cd $OUTDIR

ml gffread/0.12.7-GCCcore-11.3.0
ml AGAT/1.1.0

NEW_GFF=""ipomoea_purpurea_liftoff.gff3
OLD_GFF="/scratch/eab77806/jim_projects/ipomoea/previous_genome/Ipomoea_purpurea_annos1-cds0-id_typename-nu1-upa1-add_chr0.gid58735.gff"

NEW_FASTA="i_purpurea.fa"
OLD_FASTA="Ipomoea_purpurea.fixed_headers.fa"

# get peptide and CDS sequence from unfiltered gff
gffread $NEW_GFF \
-g /scratch/eab77806/jim_projects/ipomoea/fasta/$NEW_FASTA \
-o $NEW_FASTA.nofilter.gff3 \
--keep-genes \
-O \
-d ${NEW_FASTA}_duplication_info.nofilter \
-x $NEW_FASTA.splicedCDS.nofilter.fasta -y $NEW_FASTA.peptides.nofilter.fasta \
-W -S --sort-alpha

# get peptide and CDS sequence from filtered gff
gffread $NEW_GFF \
-g /scratch/eab77806/jim_projects/ipomoea/fasta/$NEW_FASTA \
-o $NEW_FASTA.filter.gff3 \
--keep-genes \
-O -V -H -B -P --adj-stop \
-M -d $NEW_FASTA.duplication_info -K \
--force-exons --gene2exon --t-adopt \
-x $NEW_FASTA.splicedCDS.filter.fasta -y $NEW_FASTA.peptides.filter.fasta \
-W -S --sort-alpha -l 300 -J

# get stats for preliminary gff3 file converted by AGAT
agat_sp_statistics.pl --gff $NEW_FASTA.nofilter.gff3 -o $NEW_FASTA.nofilter.gff3.stats.out

# get stats for final gff3 file filtered by gffread
agat_sp_statistics.pl --gff $NEW_FASTA.filter.gff3 -o $NEW_FASTA.filter.gff3.stats.out

# get unfiltered gff from reference
gffread $OLD_GFF \
-g /scratch/eab77806/jim_projects/ipomoea/previous_genome/$OLD_FASTA \
-o $OLD_FASTA.nofilter.gff3 \
--keep-genes \
-O \
-W -S --sort-alpha

# get stats for reference gff3 file converted by AGAT
agat_sp_statistics.pl --gff $OLD_FASTA.nofilter.gff3 -o $OLD_FASTA.nofilter.gff3.stats.out


# # get longest isoforms for busco analysis
# agat_sp_keep_longest_isoform.pl -gff $NEW_FASTA.nofilter.gff3 > {output.longest_iso_gff}
# gffread {output.longest_iso_gff} -g {input.fasta} -y {output.longest_iso_prot} >/dev/null
# """