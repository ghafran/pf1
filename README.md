
# Run on g4dn.xlarge instance (Ubuntu Server 20.04 LTS (HVM), SSD Volume Type), 120GB
# create and attach a volumne to instance gp3, 5,000GB, /dev/sdf

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

## mount volume and download databases to host
```
sudo lsblk -f
sudo mkfs -t xfs /dev/nvme1n1
sudo mkdir -p /data
mount /dev/nvme1n1 /data
sudo chmod 777 /data
```

## download data sets - this is only needed one time
```
cd /data
# we recommend saving these files in s3 for faster future downloads
# download databases
wget https://files.ipd.uw.edu/pub/RoseTTAFold/weights.tar.gz
wget http://wwwuser.gwdg.de/~compbiol/uniclust/2020_06/UniRef30_2020_06_hhsuite.tar.gz
wget https://bfd.mmseqs.com/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt.tar.gz
wget https://files.ipd.uw.edu/pub/RoseTTAFold/pdb100_2021Mar03.tar.gz
tar xfz weights.tar.gz
mkdir -p UniRef30_2020_06
tar xfz UniRef30_2020_06_hhsuite.tar.gz -C ./UniRef30_2020_06
mkdir -p bfd
tar xfz bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt.tar.gz -C ./bfd
tar xfz pdb100_2021Mar03.tar.gz
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
```
cd ~/pf1
export SEQUENCE=`cat tsp1.fa`
sudo docker run -it --rm --gpus all --name pf1test \
     -v "$(pwd)/output:/output" \
     -v "/data:/data" \
    -e "SEQUENCE=${SEQUENCE}" \
    pf1 bash 

    /bin/sh -c "/src/run.sh"
```

# Download to local drive
```
scp -r -i ~/.ssh/at.pem 'ubuntu@54.209.212.120:/home/ubuntu/pf1/output/*' './output/'
```
