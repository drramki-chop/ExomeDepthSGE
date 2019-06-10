library(ExomeDepth)

input <- yaml::read_yaml("input.yaml")
manifest <- read.table(as.character(input$manifest),header=T,sep="\t")

sampleID <- Sys.getenv("SGE_TASK_ID")
sampleName <- as.character(manifest[sampleID,2])
sampleSex <- as.character(manifest[sampleID,3])

countdf <- readRDS(paste0(as.character(input$cohort.name),".autosomes.rds"))

if(sampleSex =="F"){
	countdf.X <- readRDS(paste0(as.character(input$cohort.name),".women.rds"))
}else{
	countdf.X <- readRDS(paste0(as.character(input$cohort.name),".men.rds"))
}

countmat <- as.matrix(countdf[,5:dim(countdf)[2]])
countmat.X <- as.matrix(countdf.X[,5:dim(countdf.X)[2]])

sampleColumn <- which(colnames(countmat) %in% sampleName)

############# Autosomes
reference_list = select.reference.set(test.counts = countmat[,sampleColumn],
                                        reference.count = countmat[,-sampleColumn],
                                        bin.length=(countdf$end-countdf$start)/1000,
                                        n.bins.reduced = 10000)
reference_set = apply(
      X = as.matrix(countmat[,-sampleColumn]), 
      MAR=1, FUN=sum)
    
    all_exons = new('ExomeDepth', test=countmat[,sampleColumn], 
                    reference=reference_set,
                    formula = 'cbind(test,reference) ~ 1')
    all_exons = CallCNVs(x = all_exons, transition.probability=10^-4,
                         chromosome=countdf$chromosome, start=countdf$start,
                         end=countdf$end, name=countdf$name)
calls <- all_exons@CNV.calls
calls$sample <- sampleName

############## Sex chromosome
reference_list = select.reference.set(test.counts = countmat.X[,sampleColumn],
                                        reference.count = countmat.X[,-sampleColumn],
                                        bin.length=(countdf.X$end-countdf.X$start)/1000,
                                        n.bins.reduced = 10000)
reference_set = apply(
      X = as.matrix(countmat.X[,-sampleColumn]),
      MAR=1, FUN=sum)

    all_exons = new('ExomeDepth', test=countmat.X[,sampleColumn],
                    reference=reference_set,
                    formula = 'cbind(test,reference) ~ 1')
    all_exons = CallCNVs(x = all_exons, transition.probability=10^-4,
                         chromosome=countdf.X$chromosome, start=countdf.X$start,
                         end=countdf.X$end, name=countdf.X$name)
if (dim(all_exons@CNV.calls)[1] > 0){
	calls.X <- all_exons@CNV.calls
	calls.X$sample <- sampleName
	calls <- rbind(calls,calls.X);
}
write.table(calls,paste0("./results/",sampleName,".exomeDepthCalls.txt"),row.names = F,sep="\t",quote=F)
