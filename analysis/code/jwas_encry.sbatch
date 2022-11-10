#!/bin/bash -l
#SBATCH --job-name=accuracy
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=50G
#SBATCH --time=9-99:00:00
#SBATCH --partition=bmm
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=tjzhao@ucdavis.edu



module load julia

srun julia /group/qtlchenggrp/tianjing/encryption/jwas_encry.jl $1 $2 $3