## Running taggers script on BlueBEAR

To run the taggers batch script, please execute the following steps:

  - Create an output directory for Slurm's files (e.g. `/PhraseoRom/slurm-output`) and update the `#SBATCH --output` line in the script accordingly. This is because a large number of slurm output files will be created by the array of jobs.
  - Create the _filename_aliases.txt_ file as per the instructions in the batch script.
  - Update the `#SBATCH --array` depending on the number of files you're processing (see the instructions referenced in the previous line).
  - Copy the _run_claws_ file into an appropriate location and also update the ${CLAWS_SCRIPT} variable in the batch script. (N.B. if this is an _unusual_ location then you may need to bind an additional directory into the Singularity container, else you can get a _not found_ error.)
  - Submit a batch job to BlueBEAR using e.g. `sbatch taggers_example_batch.sh`
