# FROM ubuntu:20.04
FROM nvidia/cuda:11.4.0-base-ubuntu20.04

# install packages
RUN apt-get update
RUN apt-get install -y python3 pip wget curl git unzip nano screen

WORKDIR /tmp
RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
RUN bash Anaconda3-2020.02-Linux-x86_64.sh -b -f -p /root/anaconda3

# copy source code
COPY src /src
WORKDIR /src

# download repo
RUN git clone https://github.com/RosettaCommons/RoseTTAFold.git
WORKDIR /src/RoseTTAFold

# create conda environment for RoseTTAFold
RUN export PATH="/root/anaconda3/bin:$PATH"
RUN conda env create -f RoseTTAFold-linux.yml

# create conda environment for pyRosetta folding & running DeepAccNet
RUN conda env create -f folding-linux.yml

# install dependencies
RUN ./install_dependencies.sh

RUN chmod +x copy.sh
RUN chmod +x run.sh
