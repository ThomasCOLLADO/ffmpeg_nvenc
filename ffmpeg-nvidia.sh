#!/bin/bash

Dir=""
Rep=""

echo "#########################################################################"
echo ""
echo "Welcome to FFMPEG NVENC installer"
echo "By Tezuka Siro"
echo "V0.1 for Ubuntu 20.04/22.04 && Debian 11"
echo ""
echo "########################################################################"

###Folder creation########

read -p "Choose directory installer : " Dir

while [ -d $Dir ] ; do
    echo "This folder already exists "
    read -p "choose a valid folder : " Dir
done

echo "Creation of the installation folder !"
mkdir $Dir

if [ -d $Dir ] ; then
    echo "the folder was created successfully ! "
    cd $Dir
else
    echo "an error occurred while creating the folder...."
    exit 1
fi

######################################################

########install dependencies#########################

Read=""

echo "Tools are required for the installation of ffmpeg !"

read -p "Proceed to install ? (y/n) " Read

if [ $Read = "y" ] ; then
    echo "Installing tools.... "
    echo ""
    apt-get install git libplib-dev build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev
else
    echo "Installing ffmpeg cannot be done without the necessary tools"
    exit 1
fi

######################################################

########Installation de ffmpeg########################

Make=$Dir/nv-codec-headers
FF=$Dir/ffmpeg/
echo "Start installation"

cd $Dir

git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git

cd $Make

make install

cd $Dir

git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/

cd $FF

./configure --enable-gpl --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --enable-nvenc

make -j $(nproc)

echo "##################################################"
echo ""
echo "Installation finished"
echo ""
echo "##################################################"
exit 0
