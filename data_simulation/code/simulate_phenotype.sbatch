#!/bin/bash -l
#SBATCH --job-name=accuracy
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=20G
#SBATCH --time=9-99:00:00
#SBATCH --partition=high
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=tjzhao@ucdavis.edu



module load julia

srun julia simulate_phenotype.jl