library(ExomeDepth)
library(purrr)
library(readr)

data(exons.hg19)
data(exons.hg19.X)
exons <- rbind(exons.hg19,exons.hg19.X)
input <- yaml::read_yaml("input.yaml")
manifest <- read.table(as.character(input$manifest),header=T,sep="\t")

men <- manifest[manifest$sex == "M",]
women <- manifest[manifest$sex == "F",]

countFiles <- list.files("./temp/",pattern = "counts.*.txt")
counts <- countFiles %>%
  map(~ read_csv(file.path("./temp/", .))) %>% 
  reduce(cbind)

counts <- cbind(exons,counts)
counts.autosomes <- counts[counts$chromosome %in% c(1:22),]
counts.X <- counts[counts$chromosome %in% c("X"),]
counts.men <- cbind(counts.X[1:4],counts.X[,names(counts.X) %in% men$sampleID])
counts.women <- cbind(counts.X[1:4],counts.X[,names(counts.X) %in% women$sampleID])

saveRDS(counts.autosomes,paste0(as.character(input$cohort.name),".autosomes.rds"))
saveRDS(counts.men,paste0(as.character(input$cohort.name),".men.rds"))
saveRDS(counts.women,paste0(as.character(input$cohort.name),".women.rds"))
