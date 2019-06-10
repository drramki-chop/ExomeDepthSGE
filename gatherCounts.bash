#!/bin/bash 
#$ -V
#$ -cwd
#$ -N step2.gatherCounts

module load R/3.3.1
R CMD BATCH gatherCounts.R
