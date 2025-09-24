#!/bin/bash

cd

cd programs/

git clone https://github.com/lh3/seqtk.git;

cd seqtk; make

echo "export PATH=$PATH:/sciclone/home/ncnallapaneni/programs/seqtk" >> ~/.bashrc
