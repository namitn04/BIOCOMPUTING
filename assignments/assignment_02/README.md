Namit Nallapaneni, 9/10/25, Assignment 2

I first started by logging into the HPC using an alias I made: bora

This is already in my .zshrc file:

alias bora='ssh ncnallapaneni@bora.sciclone.wm.edu'


Once I was logged in, I did the following commands to start making the assignment architecture:

cd BIOCOMPUTING/

mkdir -p assignments/assignment_02

touch assignments/assignment_02/README.md

exit


After I logged out, I started trying to download the files from NCBI using the ftp command, but I ran into a bunch of errors.
I didn't even have ftp on my Mac and when I tried using it I got some random errors when trying to use ls or cd, which Dr. Zahn said is likely due to my OS firewall.
Not exactly sure what that meant, but I was able to bypass my issues by using the lftp command.

brew install lftp

cd

cd Desktop

lftp ftp.ncbi.nlm.nih.gov 


This finally allowed me to use cd and ls. I didn't even have to login for some reason. Once I was in the lftp command line, I did the following commands, so I could download to my Desktop:

cd genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/

ls

get GCF_000005845.2_ASM584v2_genomic.fna.gz

get GCF_000005845.2_ASM584v2_genomic.gff.gz

bye


Once I exited the lftp command line, I did an m5sum on my local machine for the two files and saved it to a file using the following commands:

md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz > download_lftp.txt

md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz >>download_lftp.txt

cat download_lftp.txt



Then I transfered the files over using sftp.


sftp ncnallapaneni@bora.sciclone.wm.edu

cd BIOCOMPUTING/assignments/assignment_02/

put GCF_000005845.2_ASM584v2_genomic.fna.gz

put GCF_000005845.2_ASM584v2_genomic.gff.gz

put download_lftp.txt

bye


Then I logged back into the cluster to confirm that the files were there and readable.


bora

cd BIOCOMPUTING/assignments/assignment_02/

ls -ahl

chmod 644 GCF_000005845.2_ASM584v2_genomic.fna.gz

chmod 644 GCF_000005845.2_ASM584v2_genomic.gff.gz

chmod 644 download_lftp.txt

ls -ahl

 
I also did another md5sum on the files that go transfered to the HPC via sftp.

md5sum GCF_000005845.2_ASM584v2_genomic.fna.gz > hpc_transfer.txt

md5sum GCF_000005845.2_ASM584v2_genomic.gff.gz >> hpc_transfer.txt 

chmod 644 hpc_transfer.txt

ls -ahl


When I checked the hashes I did:

cat download_lftp.txt

cat hpc_transfer.txt


I saw that the hashes matched, as the files had the same content: 

c13d459b5caa702ff7e1f26fe44b8ad7  GCF_000005845.2_ASM584v2_genomic.fna.gz
2238238dd39e11329547d26ab138be41  GCF_000005845.2_ASM584v2_genomic.gff.gz


Then I realized my directory was a mess so I did some clean up:

mkdir data

mkdir hash_match

mv GCF_000005845.2_ASM584v2_genomic.fna.gz data/

mv GCF_000005845.2_ASM584v2_genomic.gff.gz data/

mv hpc_transfer.txt hash_match/

mv download_lftp.txt hash_match/


My final architecture had one dir called data with the .gz files and another directory called hash_match which contains that md5sum output from the files on my local computer and the hpc. There is also a README.md.

Then I started to add those bash aliases to HPC .bashrc, so I did:

cd

nano .bashrc


I then added the aliases from the Assignment 2 Doc.

u means go back one directory, clear the screen, list everything (directories first) in a long, human-readable form and add symbols to the end of names to help you figure out what they are.

d means go back to the previous direcoty, clear the screen, list everything (directories first) in a long, human-readable form and add symbols to the end of names to help you figure out what they are.

ll means list everything (directories first) in a long, human-readable form and add symbols to the end of names to help you figure out what they are.




Overall, this wasn't too bad. The hardest thing for me was getting ftp working. I didn't know what my errors meant, so I just decided to pivot to a different command line tool 'lftp'. This worked great and everything went smoothly after. Also, I think in the future I could just use the wget command to directly download onto the HPC from the ftp?

