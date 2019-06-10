export N_SAMPLES=143
export H_VMEM=4g
export MEM_FREE=4g

module load R/3.3.1

mkdir -p temp
mkdir -p results
qsub -t 1:$N_SAMPLES -l mem_free=$MEM_FREE,h_vmem=$H_VMEM ./getCounts.bash
qsub -hold_jid step1.getCounts -l mem_free=$MEM_FREE,h_vmem=$H_VMEM ./gatherCounts.bash
qsub -t 1:$N_SAMPLES -hold_jid step1.getCounts,step2.gatherCounts -l mem_free=$MEM_FREE,h_vmem=$H_VMEM ./callVariants.bash
qsub -hold_jid step1.getCounts,step2.gatherCounts,step3.callVariants -l mem_free=$MEM_FREE,h_vmem=$H_VMEM ./gatherCalls.bash
