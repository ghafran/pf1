#!/bin/bash

nvidia-smi
nvidia-smi --list-gpus | wc -l

# attach database volume
rm /src/RoseTTAFold/pdb100_2021Mar03
rm /src/RoseTTAFold/UniRef30_2020_06
rm /data/bfd/src/RoseTTAFold/bfd
ln -s /data/ /src/RoseTTAFold/pdb100_2021Mar03
ln -s /data/ /src/RoseTTAFold/UniRef30_2020_06
ln -s /data/bfd/src/RoseTTAFold/bfd 

mkdir -p /src/RoseTTAFold/output
cp /src/RoseTTAFold/example/input.fa /src/RoseTTAFold/output/input.fa
cd /src/RoseTTAFold/output
../run_e2e_ver.sh input.fa . 
# ../run_pyrosetta_ver.sh input.fa .

/src/copy.sh