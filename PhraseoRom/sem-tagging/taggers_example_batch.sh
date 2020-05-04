#!/bin/bash

#SBATCH --qos bbshort  # For executing array jobs
#SBATCH --time 5  # Allow 5 minutes for each job in the array. This is may need increasing if input files are huge
#SBATCH --ntasks 1
#SBATCH --array 1-492  # change this value depending on the number of files you want to process
#SBATCH --output /PhraseoRom/slurm-output/slurm-%A_%a.out

set -e

module purge; module load bluebear  # this line is required

# We'll define a couple of environment variables to keep things neat

# This is so that we can conveniently bind the project directory into the Singularity container, giving us access to the various subdirectory content that's required.
BASE_DIR= #CHANGEME

SINGULARITY_IMAGE=/software/containers/taggers.sif

# This is an edited run_claws script to stop repeated symbolic link creation and deletion (which could affect other array jobs)
CLAWS_SCRIPT=/software/run_claws

# Location of input content
CONTENT_DIR=/PhraseoRom/api-output

# Run command: `cd ${CONTENT_DIR} && find . -name "*.txt" > ../filename_aliases.txt` from within the content directory to
# get a list of relative paths for aliasing to the task ID.
# N.B. running `wc --lines ${FILENAME_ALIASES}` will give you the array job size to use
FILENAME_ALIASES=/PhraseoRom/filename_aliases.txt

# This sed command uses the SLURM_ARRAY_TASK_ID variable to extract a given line from the list of filepaths
FILEPATH_RELATIVE=$(sed "${SLURM_ARRAY_TASK_ID}q;d" ${FILENAME_ALIASES})

CONTENT_PREFIX=${CONTENT_DIR}/$(dirname ${FILEPATH_RELATIVE})

FILENAME=$(basename ${FILEPATH_RELATIVE})

echo "Executing job ${SLURM_ARRAY_TASK_ID} of ${SLURM_ARRAY_TASK_MAX}"
echo "Processing filename ${CONTENT_DIR}/${FILEPATH_RELATIVE} ..."

# Change directory to where the content is
cd ${CONTENT_PREFIX}
# Run the commands to process the data
singularity exec --bind ${BASE_DIR}:${BASE_DIR} ${SINGULARITY_IMAGE} ${CLAWS_SCRIPT} ./${FILENAME}
singularity exec --bind ${BASE_DIR}:${BASE_DIR} ${SINGULARITY_IMAGE} semtag -aux ./${FILENAME}.c7 ./${FILENAME}.sem

# You might want to put some additional commands here to tidy-up any files that you don't need in the future,
# given that the two scripts above create a large amount of output. Alternatively you could copy the .sem file to
# a different folder, assuming that this is the one you care most about.
