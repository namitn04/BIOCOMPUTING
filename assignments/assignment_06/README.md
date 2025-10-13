cd ~/BIOCOMPUTING/assignments/assignment_06/

nano README.md

mkdir -p assemblies/assembly_{conda,local,module}

mkdir data scripts

ls -R

---

cd scripts/

touch 01_download_data.sh 

chmod +x 01_download_data.sh 

nano 01_download_data.sh

---

#!/bin/bash

wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz

gunzip SRR33939694.fastq.gz

---

I had:

rm SRR33939694.fastq.gz 

In the script before, but I realized I didn't need it bc gunzip removes the zipped file.

So I ran:

rm data/SRR33939694.fastq 

Deleted rm SRR33939694.fastq.gz from the script and ran it again from the data directory.

cd ~/BIOCOMPUTING/assignments/assignment_06/data

../scripts/01_download_data.sh 

---

cd ~/BIOCOMPUTING/assignments/assignment_06/

cd scripts/

nano flye_2.9.6_manual_build.sh

chmod +x flye_2.9.6_manual_build.sh


exit

bora


it worked when I call:

flye
---

nano flye_2.9.6_conda_install.sh

chmod +x flye_2.9.6_conda_install.sh 

module load miniforge3/

source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"

conda activate flye-env

flye -v spits out: 2.9.6-b1802

conda env export --no-builds > flye-env.yml

conda deactivate




