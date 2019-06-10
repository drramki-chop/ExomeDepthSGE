library(ExomeDepth)

data(exons.hg19)
data(exons.hg19.X)
exons <- rbind(exons.hg19,exons.hg19.X)

input <- yaml::read_yaml("input.yaml")
manifest <- read.table(as.character(input$manifest),header=T,sep="\t")

sampleID <- Sys.getenv("SGE_TASK_ID")

results <- as.data.frame(getBamCounts(bed.frame= exons,bam.files =as.character(manifest[sampleID,1])))
results <- as.data.frame(results[,dim(results)[2]])
names(results) <- as.character(manifest[sampleID,2]);

write.table(results,paste0("./temp/counts.",sampleID,".txt"),row.names=F,quote=F)

