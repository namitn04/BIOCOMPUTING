# Namit Nallapaneni, Assignment 05, 9/30/25

## Task 1 - Setup assignment_5/ directory
#### This was super easy and is second-nature by now.

cd ~/BIOCOMPUTING/

cd assignment_05/

mkdir -p data/{raw,trimmed} log scripts

touch pipeline.sh

chmod +x pipeline.sh

touch scripts/01_download_data.sh scripts/02_run_fastp.sh

cd scripts

chmod +x 01_download_data.sh 02_run_fastp.sh 

nano README.md

#### I made a dir titled raw with two subdirectories (raw and trimmed) and two more dirs titled log and scripts. I made a pipeline.sh script in the assignment 5 dir, as well two scripts in the scripts directory. I also made all these scripts executable. Finally, I made a README.md to document my work.

## Task 2 - Script to download and prepare fastq data
#### This was also pretty straightforward. I made a variable for my home directory and used it to navigate to the data/raw dir. I then downloaded and unzipped the file. I used tar -xf because tar -xzf gave me an error. I then removed the tar at the end to clean up everything. 

#!/bin/bash

set -ueo pipefail

MAIN=${HOME}/BIOCOMPUTING/assignments/assignment_05

cd ${MAIN}

cd data/raw/

wget https://gzahn.github.io/data/fastq_examples.tar

tar -xf fastq_examples.tar

rm fastq_examples.tar

#### I ran the script using the following lines:

cd ~/BIOCOMPUTING/assignment_05/

./scripts/01_download_data.sh 

## Task 3 - Install and explore the fastp tool

#### I installed/setup fastp in my programs dir using the following lines:

cd ~/programs

wget http://opengene.org/fastp/fastp

chmod a+x ./fastp

#### This worked perfectly and I was able to use fastp immediately, as I already had the following line in my .bashrc:

export PATH=$PATH:/sciclone/home/ncnallapaneni/programs

## Task 4 - Script to run fastp

#### This was super easy, especially with the hint (thank you Dr. Zahn)! I believe this script is taking in a forward and reverse read and is spitting out a trimmed version of each (remove 8 nuc. from front and 20 nuc. from back). However, it also discards any reads shorter than 100 bp and any reads that have an average quality score under 20.

#!/bin/bash

FWD_IN=$1

REV_IN=${FWD_IN/_R1_/_R2_}

FWD_OUT=${FWD_IN/.fastq.gz/.trimmed.fastq.gz}

REV_OUT=${REV_IN/.fastq.gz/.trimmed.fastq.gz}

fastp --in1 $FWD_IN --in2 $REV_IN --out1 ${FWD_OUT/raw/trimmed} --out2 ${REV_OUT/raw/trimmed} --json /dev/null --html /dev/null --trim_front1 8 --trim_front2 8 --trim_tail1 20 --trim_tail2 20 --n_base_limit 0 --length_required 100 --average_qual 20

#### I ran the script using the following lines:

cd ~/BIOCOMPUTING/assignment_05/

./scripts/02_run_fastp.sh ./data/raw/6083_001_S1_R1_001.subset.fastq.gz

## Task 5 - `pipeline.sh` script

#### This was pretty straightforward as well. 

#!/bin/bash

set -ueo pipefail

MAIN=${HOME}/BIOCOMPUTING/assignments/assignment_05

cd ${MAIN}

echo "run script 01"

./scripts/01_download_data.sh

echo "run script 02"

for i in ./data/raw/*R1*; do ./scripts/02_run_fastp.sh $i; done

echo "sucess!"

#### I made a variable for my assignment_05 dir and the navigated to it. I then added an echo line for a sanity check and ran the script with the same command as I did before. I then added another a second echo line for another sanity check and made a for loop that iterates through every forward read in the data directory, as that is how the 02 script parses, and runs the 02_run_fastp on all those reads. Finally I echo "sucess!" to see if my code works.

## Task 6 - Delete all the data files and start over

#### Before I ran the pipeline.sh, I deleted all the files I downloaded/made:

cd ~/BIOCOMPUTING/assignments/assignment_05/data/raw

rm *

cd ..

cd trimmed 

rm *

#### I ran the script using the following lines:

cd ~/BIOCOMPUTING/assignments/assignment_05

./pipeline.sh

#### This worked perfectly. I was worried I was going to get kicked off the cluster because of how long it was taking though. 

## Task 8 - Push to GitHub

cd ~/BIOCOMPUTING/

nano .gitignore

#### I added this to my gitignore so I wouldn't accidentally add a bunch of my junk to my commit history and ruin my life.

assignments/assignment_05/data/

## Reflection

I didn't have any major challenges to overcome. This assignment felt pretty straightfoward to me. I learned how to call scripts within scripts, which I think will become very fun and useful in the near future. My understanding of why we split the process into two scripts was to make the final script more modular, so that it would be easier to swap in and out various scripts. Like in this case, we could swap in another 01 script so we could download a different set of files with similar structure. The only con I can see from this approach is that you have to think harder about making things modular.
