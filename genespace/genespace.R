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

gpar <- init_genespace(wd = wd, path2mcscanx = path2mcscanx, nCores = 16,
                       dotplots = "never")

out <- run_genespace(gpar)
