# ExomeDepthSGE
  To process a cohort of samples through ExomeDepth pipeline in respublica. The counting and calling steps are implemented in array jobs and scales well with thousands of samples. Depends on the maximum number of slots available to the user.
  
## Dependencies
  * R
  * ExomeDepth (package)
  * yaml (package)
  * purrr (package)
  * readr (package)

## Running on SGE environment

  * Needs a tab-delimited manifest (column1 - bam, column2 - sample name, column3 - sex)
  * input.yaml needs to be edited to reflect the name of the manifest file and the name of the cohort.
  * `mainscript.sh` should be edited for the N_SAMPLES (number of samples) in the manifest file.
  * The memory variables H_VMEM and MEM_FREE are set based on our experience processing 100x exomes with Agilent SureSelect       V5. Memory requirements for the `step2` gatherCounts need to be edited according to the size of the cohort. 
  
## Notes
  * If your jobs fail: 
    1) Check if the cluster environment sees your R setup or your packages.
    2) Check the exit status of your job (qacct -j). Most of the times, its the memory.
  * It takes about 20-30 minutes processing ~300 samples from start to finish (variant calls).
  
  
## To Do

  * Modify the workflow to parse the yaml file in shell. This will eliminate the need to edit two files (input.yaml and the       mainScript.sh)
  * Add annotation step.
  * Add option to provide user-defined BED file.
  
  
  
