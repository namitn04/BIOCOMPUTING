# Namit Nallapaneni, 10/14/25, Assignment 6

## Task 1

connected to VPN, SSH’d into bora, and went to the assignment folder:

---

bora

cd ~/BIOCOMPUTING/assignments/assignment_06/

---

made the initial folders and a README:

---

nano README.md

mkdir -p assemblies/assembly_{conda,local,module}

mkdir data scripts

ls -R

---

## Task 2

wrote the download script and made it executable:

---

cd scripts/

touch 01_download_data.sh

chmod +x 01_download_data.sh

nano 01_download_data.sh

---

#!/bin/bash

set -ueo pipefail

mkdir -p data

cd data

wget https://zenodo.org/records/15730819/files/SRR33939694.fastq.gz

gunzip SRR33939694.fastq.gz

---

note: I originally had rm SRR33939694.fastq.gz in this script, but realized gunzip already removes the .gz.

I also did a cleanup once when testing:

---

rm -rf data/

---

then I removed the extra rm from the script and ran it again from the repo root:

---

cd ~/BIOCOMPUTING/assignments/assignment_06/

./scripts/01_download_data.sh

---

## Task 3

### manual (local) build

I set up a local build to have a “no-conda” version:

---

cd ~/BIOCOMPUTING/assignments/assignment_06/

cd scripts/

nano flye_2.9.6_manual_build.sh

chmod +x flye_2.9.6_manual_build.sh

---

#!/bin/bash

set -ueo pipefail

cd

cd programs/

git clone https://github.com/fenderglass/Flye

cd Flye

make

echo "export PATH=\$PATH:/sciclone/home/ncnallapaneni/programs/Flye/bin" >> ~/.bashrc

---

I sourced exited and relogged into bora, then checked:

flye

(it worked)

I changed this later. The update is in Task 10.

---

## Task 4

### conda build

Then I installed Flye via conda (using miniforge3) and exported the env:

---

cd ~/BIOCOMPUTING/assignments/assignment_06/

cd scripts/

nano flye_2.9.6_conda_install.sh

chmod +x flye_2.9.6_conda_install.sh

---

module load miniforge3

export CONDA_PKGS_DIRS="$HOME/.conda/pkgs"

source /sciclone/apps/miniforge3-24.9.2-0/etc/profile.d/conda.sh

mamba create -n flye-env -c conda-forge -c bioconda flye=2.9.6 -y

conda activate flye-env

flye -v  *(This was 2.9.6-b1802)*

conda env export --no-builds > flye-env.yml

conda deactivate

---

note: ChatGPT helped me figure out the export line, for some reason I was getting errors without it, but I believe this line should be reproducible because I am using the $HOME variable.

---

## Task 5


I ran this command in the data dir to test Flye and it worked. I added the meta tag because there is likely multiple phage in the data.

---

flye --nano-hq SRR33939694.fastq --out-dir test/ --threads 6 --meta

---

## Task 6

### A

This was my script for the conda build.

---

#!/bin/bash

set -ueo pipefail

mkdir -p assemblies/assembly_{conda,conda_build}

module load miniforge3

source "$(dirname $(dirname $(which conda)))/etc/profile.d/conda.sh"

conda activate flye-env

conda env export --no-builds > flye-env.yml

flye --nano-hq data/SRR33939694.fastq --out-dir ./assemblies/assembly_conda_build --threads 6 --meta

conda deactivate

mv assemblies/assembly_conda_build/assembly.fasta assemblies/assembly_conda/conda_assembly.fasta

mv assemblies/assembly_conda_build/flye.log assemblies/assembly_conda/conda_flye.log

rm -rf assemblies/assembly_conda_build/

---

### B

This was my script for the module build.

---

#!/bin/bash

set -ueo pipefail

mkdir -p assemblies/assembly_{module,module_build}

module load Flye/gcc-11.4.1/2.9.6 

flye --nano-hq data/SRR33939694.fastq --out-dir ./assemblies/assembly_module_build --threads 6 --meta

mv assemblies/assembly_module_build/assembly.fasta assemblies/assembly_module/module_assembly.fasta

mv assemblies/assembly_module_build/flye.log assemblies/assembly_module/module_flye.log

rm -rf assemblies/assembly_module_build/

---

### C

This was my script for the local build.

---

#!/bin/bash

set -ueo pipefail

mkdir -p assemblies/assembly_{local,local_build}

flye --nano-hq data/SRR33939694.fastq --out-dir ./assemblies/assembly_local_build --threads 6 --meta

mv assemblies/assembly_local_build/assembly.fasta assemblies/assembly_local/local_assembly.fasta

mv assemblies/assembly_local_build/flye.log assemblies/assembly_local/local_flye.log

rm -rf assemblies/assembly_local_build/

---

I confirmed each of these scripts were properly referencing the right flye by using:

which flye

I also ran them all from the assignment_06 dir by doing ./scripts/whatever_script_it_was.sh

---

## Task 7

I used the following commands to parse through the log files. Everything matched between runs.

---

tail assemblies/assembly_conda/conda_flye.log -n 10

tail assemblies/assembly_local/local_flye.log -n 10

tail assemblies/assembly_module/module_flye.log -n 10

---

## Task 8

This was my pipeline.sh script, it worked:

---

#!/bin/bash

set -ueo pipefail

./scripts/01_download_data.sh 

./scripts/flye_2.9.6_manual_build.sh

./scripts/flye_2.9.6_conda_install.sh

./scripts/03_run_flye_local.sh

./scripts/03_run_flye_conda.sh

./scripts/03_run_flye_module.sh

echo "Log data for conda usuage of flye:"

tail assemblies/assembly_conda/conda_flye.log -n 10 

echo "Log data for local usuage of flye:"

tail assemblies/assembly_local/local_flye.log -n 10 

echo "Log data for module usuage of flye:"

tail assemblies/assembly_module/module_flye.log -n 10 

---

## Task 9

I deleted everything and ran the script again from my assignment 6 dir. I also deleted flye from my programs dir and from my bashrc. It all worked when I ran it again!

---

## Task 10

---

I added this line to my script for manually building flye at the end because I realized the path won't be the same for all users.

echo 'export PATH=$PATH:$HOME/programs/Flye/bin' >> ~/.bashrc

--- 

I ran this line so my dirs would get uploaded to git:

touch assemblies/assembly_conda/blank assemblies/assembly_module/blank assemblies/assembly_local/blank data/blank  

---

What pipeline.sh does:

From the assignment_06 directory, run:

./scripts/pipeline.sh

---

The script runs everything in order:

1. Downloads the read data.

2. Builds a **local** copy of Flye from source.

3. Creates a **Conda** environment with flye=2.9.6.

4. Runs Flye three ways:
   * using the **Conda** env,
   * using your **local build**,
   * using the **module** version on the cluster.

5. For each run, it saves outputs under assemblies/ and logs under each run’s folder.

6. At the end, it prints a quick comparison:
   * the **last 10 lines** from each log (in this order: Conda, Local, Module),
   * and the **exact Flye binary path** each run used, so you can confirm it switched correctly.

Paths may vary a bit depending on how your BIOCOMPUTING folder is laid out, but if you start in assignment_06 and use the command above, you’re set.

---

Overall this was pretty straightforward from class. The only real hiccup was setting up the Conda environment on the HPC. I fixed it by adding the line to point Conda’s package directory to my home. That made sense once I realized you need your own writable cache on the cluster. I actually learned how to use Conda and build with it instead of just copy-pasting Biostars commands. For methods, I prefer the module or a local build. If a module exists, I’ll use that first since it’s maintained. If not, I’ll try a local install if it isn’t a pain. Conda works, but it can be flaky on shared systems.
