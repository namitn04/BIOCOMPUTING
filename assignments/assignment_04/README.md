# Namit Nallapaneni, Assignment 04, 9/22/25

# Task 1

## I already had the following line in my .bashrc

export PATH=$PATH:/sciclone/home/ncnallapaneni/programs

# Task 2

## This is me navigating to the programs folder, downloading the the gh file, unzipping it, and deleting the original file

cd 

cd programs/

wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

tar -xzvf gh_2.74.2_linux_amd64.tar.gz 

rm gh_2.74.2_linux_amd64.tar.gz 

# Task 3

## In my assignment 4 directory, I made a dir called scripts

cd

cd BIOCOMPUTING/assignments/assignment_04/

mkdir scripts

cd scripts/

nano install_gh.sh

## Here I basically copied my Task 2 commands but added a shebang to start the script

#!/bin/bash

cd 

cd programs/

wget https://github.com/cli/cli/releases/download/v2.74.2/gh_2.74.2_linux_amd64.tar.gz

tar -xzvf gh_2.74.2_linux_amd64.tar.gz

rm gh_2.74.2_linux_amd64.tar.gz

cd

## I added a cd at the end to get out of the programs directory, but I'm not sure if this does anything

# Task 4

## I ran it by first deleting the old gh auth, then I cd'ed to my script, made it executable, then used ./ to run it

cd ~/programs/

rm -rf gh_2.74.2_linux_amd64

cd BIOCOMPUTING/assignments/assignment_04/scripts/

./install_gh.sh 

# Task 5

## I added the following line to the bottom of my .bashrc
export PATH=$PATH:/sciclone/home/ncnallapaneni/programs/gh_2.74.2_linux_amd64/bin

## I then exited and reconnected the cluster to make sure my .bashrc was working (source .bashrc hasn't been working for me for some reason)

# Task 6

gh auth login

## This worked perfectly, I just copied and pasted my token in and it was smooth 

cd BIOCOMPUTING/

git pull

# Task 7

## The following commands are what I did to make sure I could download and setup everything regularly
cd

cd programs/

git clone https://github.com/lh3/seqtk.git;

cd seqtk; make

echo "export PATH=$PATH:/sciclone/home/ncnallapaneni/programs/seqtk" >> ~/.bashrc

## I then exited and reconnected to the cluster and I was able to get a help message from seqtk

## I then deleted the seqtk dir and the line from .bashrc so I could now make a script automating the download

nano install_seqkt.sh

chmod +x install_seqkt.sh

## This is what my script had and it worked 

#!/bin/bash

cd

cd programs/

git clone https://github.com/lh3/seqtk.git;

cd seqtk; make

echo "export PATH=$PATH:/sciclone/home/ncnallapaneni/programs/seqtk" >> ~/.bashrc

# Task 8

## seqtk was pretty easy and intuitive to work with

cd ~/BIOCOMPUTING/assignments/assignment_03/data

seqtk 

## This gave me a help message and all the list of possible commands

## I tried passing commands to all of the possible flags, but some confused me like sample and famask

## THIS ONE WAS EVIL TO START! IT CRASHED MY TERMINAL!

seqtk seq GCF_000001735.4_TAIR10.1_genomic.fna 

# Task 9

## I read ahead and saw that I needed some fasta files so I copied over and made duplicates of the one from assignment 3 into a new data directory in assignment 4

cd ~/BIOCOMPUTING/assignments/assignment_04/

mkdir data

cd data/

cp ~/BIOCOMPUTING/assignments/assignment_03/data/GCF_000001735.4_TAIR10.1_genomic.fna ~/BIOCOMPUTING/assignments/assignment_04/data/

cp GCF_000001735.4_TAIR10.1_genomic.fna test_1.fna

cp GCF_000001735.4_TAIR10.1_genomic.fna test_2.fna

cp GCF_000001735.4_TAIR10.1_genomic.fna test_3.fna

rm GCF_000001735.4_TAIR10.1_genomic.fna 

## Making this script was pretty easy

## I referred to some of the grep commands from assignment 3 to confirm my new commands using seqtk were right

grep -i ">" ${FILENAME} -c

seqtk size ${FILENAME} | cut -f1

## These matched

grep -i ">" ${FILENAME} -v | tr -d "\n" | wc -m

seqtk size ${FILENAME} | cut -f2

## These also matched

## This is what my script ended up looking like:

#!/bin/bash

FILENAME=${1}

echo "This is the filename: ${FILENAME}" 

#grep -i ">" ${FILENAME} -c

NUMSEQ=$(seqtk size ${FILENAME} | cut -f1)

#grep -i ">" ${FILENAME} -v | tr -d "\n" | wc -m

NUMNUC=$(seqtk size ${FILENAME} | cut -f2)

echo "${NUMSEQ} is the total number of sequences"

echo "${NUMNUC} is the total number of nucleotides"

TABLE=$(seqtk comp ${FILENAME} | cut -f1,2)

echo -e "THIS IS THE TABLE:\n${TABLE}"

## shout out Sarah she showed me that the -e command helps recognize \n as a new line

# TASK 10

## This was the for loop command that ran through my duplicate fasta files in my data folder

cd ~/BIOCOMPUTING/assignments/assignment_04/scripts/

for i in ~/BIOCOMPUTING/assignments/assignment_04/data/*; do ./summarize_fasta.sh $i; done

## This worked perfectly

## Overall, I didn't have many challenges on my computer. I worked with Sarah on this assignment and it seemed like we were running the same commands, but seqtk just would not work. I'm not truly sure what fixed it bc we just ended up wiping eveything and trying again. Other than that I didn't have any issues.

## I was really happy to learn how to make scripts to automate simple tasks. I remember my time on the W&M iGEM team and having to manually download and refresh databases. Now I can make a script to do that for me! I'm very excited to automate random simple things. 

## $PATH is an environmental variable that tells the machine where to look for specific binaries/programs of interest. By appending new paths to $PATH you can give it a new place to look for a specific program/its binary.

