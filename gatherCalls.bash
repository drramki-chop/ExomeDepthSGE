#!/bin/bash 
#$ -V
#$ -cwd
#$ -N step4.gatherCalls

module load R/3.3.1
R CMD BATCH gatherCalls.R
