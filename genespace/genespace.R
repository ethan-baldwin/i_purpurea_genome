library(GENESPACE)

setwd("/scratch/eab77806/jim_projects/ipomoea/genespace")

genomeRepo <- "genomeRepo"
wd <- "."
path2mcscanx <- "/apps/eb/MCScanX/20221031-GCC-11.3.0/"



genomes2run <- c("i_triloba", "i_trifida","i_purpurea","i_nil")

parse_annotations(rawGenomeRepo=genomeRepo,
                  genomeDirs = genomes2run,
                  genomeIDs = genomes2run,
                  gffString = "gff3",
                  faString = "faa",
                  genespaceWd=wd,
                  troubleShoot = FALSE,
                  headerEntryIndex = 1,
                  overwrite = F,
                  headerSep=" ",
                  gffIdColumn = "ID")

gpar <- init_genespace(wd = wd, path2mcscanx = path2mcscanx, nCores = 4,
                       dotplots = "never")

out <- run_genespace(gpar,overwrite=TRUE)

invchr <- data.frame(genome = c("i_purpurea","i_purpurea","i_purpurea","i_purpurea","i_purpurea","i_nil","i_nil","i_nil","i_nil","i_purpurea","i_nil"),
                     chr = c("scaffold_7","scaffold_2","scaffold_3","scaffold_9","scaffold_8","chr11","chr7","chr6","chr3","scaffold_6","chr13"))


ripDat <- plot_riparian(
  gsParam = gpar,
    # refGenome = "i_purpurea",
  useOrder = FALSE,
  minChrLen2plot=10000000,
  forceRecalcBlocks = FALSE,
  invertTheseChrs = invchr
)

# output plot to pdf
pdf(file="riparian_bp.pdf", width = 10)
ripDat
dev.off()

ripDat <- plot_riparian(
  gsParam = gpar,
  refGenome = "i_purpurea",
  useOrder = TRUE,
  minChrLen2plot=1000,
  forceRecalcBlocks = FALSE,
  invertTheseChrs = invchr
)

# output plot to pdf
pdf(file="riparian_gene_order.pdf", width = 10)
ripDat
dev.off()