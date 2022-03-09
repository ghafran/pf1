# FROM ubuntu:20.04
FROM nvidia/cuda:11.4.0-base-ubuntu20.04

# copy source code
COPY src /src
WORKDIR /src

# install packages
RUN apt-get update
RUN apt-get install -y python3 pip wget git unzip nano

# download repo
RUN git clone https://github.com/RosettaCommons/RoseTTAFold.git
WORKDIR /src/RoseTTAFold

# download databases
RUN wget https://files.ipd.uw.edu/pub/RoseTTAFold/weights.tar.gz
RUN tar xfz weights.tar.gz

RUN ./install_dependencies.sh

# uniref30 [46G]
RUN wget http://wwwuser.gwdg.de/~compbiol/uniclust/2020_06/UniRef30_2020_06_hhsuite.tar.gz
RUN mkdir -p UniRef30_2020_06
RUN tar xfz UniRef30_2020_06_hhsuite.tar.gz -C ./UniRef30_2020_06

# BFD [272G]
RUN wget https://bfd.mmseqs.com/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt.tar.gz
RUN mkdir -p bfd
RUN tar xfz bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt.tar.gz -C ./bfd

# structure templates (including *_a3m.ffdata, *_a3m.ffindex) [over 100G]
RUN wget https://files.ipd.uw.edu/pub/RoseTTAFold/pdb100_2021Mar03.tar.gz
RUN tar xfz pdb100_2021Mar03.tar.gz

