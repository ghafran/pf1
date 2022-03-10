#!/bin/bash

# ensure gpu available
nvidia-smi

# attach database volume
ln -s /data/weights /src/RoseTTAFold/weights
ln -s /data/pdb100_2021Mar03 /src/RoseTTAFold/pdb100_2021Mar03
ln -s /data/UniRef30_2020_06 /src/RoseTTAFold/UniRef30_2020_06
ln -s /data/bfd /src/RoseTTAFold/bfd

# create input file
mkdir -p /src/RoseTTAFold/output
cd /src/RoseTTAFold/output
cp /src/$SEQUENCE /src/RoseTTAFold/output/input.fa

# run fold
../run_e2e_ver.sh input.fa .
# ../run_pyrosetta_ver.sh input.fa .

# copy output to host
/src/copy.sh
