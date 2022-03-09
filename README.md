
# Run on g4dn.xlarge instance (Ubuntu Server 20.04 LTS (HVM), SSD Volume Type)

## install nvidia drivers on host
```
ssh -i ~/.ssh/at.pem ubuntu@54.209.212.120
sudo apt update
sudo apt upgrade -y
sudo apt install -y gcc
sudo apt install -y linux-headers-$(uname -r)
sudo apt install -y nvidia-driver-460
sudo reboot
nvidia-smi
nvidia-smi --list-gpus | wc -l
```

## install docker and nvidia docker toolkit on host
```
curl https://get.docker.com | sh && sudo systemctl --now enable docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

## build docker image
This must run on a host with nvidia gpu and drivers
```
cd ~
git clone https://github.com/ghafran/pf1
cd ~/pf1
sudo docker build -t pf1 .
```
At this, point we should push the built image to an image respository

## run fold prediction
This must run on a host with nvidia gpu and drivers
```
cd ~/pf1
sudo docker run -it --rm --gpus all --name pf1test \
     -v "$(pwd)/output:/output" \
    -e "NAME=tsp1" \
    -e "SEQUENCE=MAAPTPADKSMMAAVPEWTITNLKRVCNAGNTSCTWTFGVDTHLATATSCTYVVKANANASQASGGPVTCGPYTITSSWSGQFGPNNGFTTFAVTDFSKKLIVWPAYTDVQVQAGKVVSPNQSYAPANLPLEHHHHHH" \
    pf1 /bin/sh -c "/src/run.sh"
```

# Download
```
scp -r -i ~/.ssh/at.pem 'ubuntu@54.209.212.120:/home/ubuntu/pf1/output/*' './output/'
```



2.	Place databaseBuild.sh on /RoseTTAFold/ and run it as nohup
 nohup sh databaseBuild.sh &

Usage
1.	Cd RoseTTAFold/example
2.	../run_e2e_ver.sh input.fa . 
Note: input.fa file contains protein sequence 
      . all logs/files will be placed on current directory 

