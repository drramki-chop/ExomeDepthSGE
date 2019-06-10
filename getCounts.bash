#!/bin/bash 
#$ -V
#$ -cwd
#$ -N step1.getCounts

module load R/3.3.1
R CMD BATCH getCounts.R
