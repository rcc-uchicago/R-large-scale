#!/bin/bash

# Configure Slurm.
export SACCT_FORMAT="jobid,partition,user,account%12,alloccpus,node%12,elapsed,totalcpu,maxRSS,ReqM"
export SQUEUE_FORMAT="%13i %12j %10P %10u %12a %8T %9r %10l %.11L %5D %4C %8m %N"

