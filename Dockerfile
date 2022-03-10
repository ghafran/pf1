FROM nvidia/cuda:11.4.0-base-ubuntu20.04

# Use bash to support string substitution.
SHELL ["/bin/bash", "-c"]

# install packages
RUN apt-get update
RUN apt-get install -y python3 pip wget curl git unzip nano screen

WORKDIR /tmp
RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
RUN bash Anaconda3-2020.02-Linux-x86_64.sh -b -f -p /opt/conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' >> ~/.bashrc
ENV PATH="/opt/conda/bin:$PATH"
RUN conda update -qy conda

# copy source code
COPY src /src
WORKDIR /src

# download repo
RUN git clone https://github.com/RosettaCommons/RoseTTAFold.git
WORKDIR /src/RoseTTAFold

# create conda environment for RoseTTAFold
RUN conda env create -f RoseTTAFold-linux.yml

# create conda environment for pyRosetta folding & running DeepAccNet
RUN conda env create -f folding-linux.yml

# install dependencies
RUN ./install_dependencies.sh

RUN chmod +x copy.sh
RUN chmod +x run.sh
