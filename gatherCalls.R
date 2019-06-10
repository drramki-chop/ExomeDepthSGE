library(purrr)
library(readr)

input <- yaml::read_yaml("input.yaml")
cnvFiles <- list.files("./results/",pattern = "*.exomeDepthCalls.txt")
calls <- cnvFiles %>%
  map(~ read_table(file.path("./results/", .))) %>% 
  reduce(rbind)
write.table(calls,paste0(as.character(input$cohort.name),".exomeDepthCalls.txt"),row.names=F,sep="\t",quote=F)

