#!/bin/bash 
#$ -V
#$ -cwd
#$ -N step3.callVariants

module load R/3.3.1
R CMD BATCH callVariants.R
