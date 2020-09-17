#!/bin/bash

#SBATCH --job-name=cnmfe_original_caiman                   #This is the name of your job
#SBATCH --cpus-per-task=4                  #This is the number of cores reserved
#SBATCH --mem-per-cpu=50G              #This is the memory reserved per core.
#SBATCH --tmp=150G

#SBATCH --time=04:00:00        #This is the time that your task will run
#SBATCH --qos=6hours           #You will run in this queue

# Paths to STDOUT or STDERR files should be absolute or relative to current working directory
#SBATCH --output=results/myrun.o%j     #These are the STDOUT and STDERR files
#SBATCH --error=results/myrun.e%j
#SBATCH --mail-type=END,FAIL,TIME_LIMIT
#SBATCH --mail-user=kevin.yamauchi@unibas.ch        #You will be notified via email when your task ends or fails


#Remember:
#The variable $TMPDIR points to the local hard disks in the computing nodes.
#The variable $HOME points to your home directory.
#The variable $SLURM_JOBID stores the ID number of your job.

# set environment variables
export MKL_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export VECLIB_MAXIMUM_THREADS=1

#load your required modules below
#################################
module purge
module load Anaconda3

#add your command lines below
#############################
echo "moving files"
cp /scicore/home/donafl00/yamauc0000/maria_data/short_movie/split_file/permissive_settings_pw_new_env/results/memmap__d1_700_d2_810_d3_1_order_C_frames_6000_.mmap $TMP

echo "analysis"
source activate caiman
conda env export > results/job_$SLURM_JOBID_env.yml

python /scicore/home/donafl00/yamauc0000/test-caiman/testcaiman/cnmfe.py --file $TMP/memmap__d1_700_d2_810_d3_1_order_C_frames_6000_.mmap --ncpus 4 --mc_settings mcorr_settings.json --cnmf_settings cnmf_settings.json --qc_settings default

for file in $TMP/*.mmap; do cp "$file" results;done
for file in $TMP/*.hdf5; do cp "$file" results;done
for file in $TMP/*.pkl; do cp "$file" results;done
