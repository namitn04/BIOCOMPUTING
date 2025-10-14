#!/bin/bash

set -ueo pipefail

cd

cd programs/

git clone https://github.com/fenderglass/Flye

cd Flye

make

# echo "export PATH=$PATH:/sciclone/home/ncnallapaneni/programs/Flye/bin" >> ~/.bashrc

echo 'export PATH=$PATH:$HOME/programs/Flye/bin' >> ~/.bashrc
