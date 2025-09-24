
# Namitchandra Nallapaneni, 9/17/25, Assignment 03

# TASK 1 - Make assignment structure

cd BIOCOMPUTING/

cd assignments/

ls

mkdir assignment_03

mkdir -p assignment_0{5..8}

## I already had directories for assignments 1, 2, & 4

cd assignment_03/

mkdir data

touch README.md

## My assignment is strucutured to have a README.md, as well as a data directory where the fasta seq is located and any new files I may create.

## After realizing the fasta files can't be pushed to my git main, I just added an empty file called blank.fasta in the data directory using touch. 

# TASK 2 - Download and prep files

cd data/

wget https://gzahn.github.io/data/GCF_000001735.4_TAIR10.1_genomic.fna.gz

gunzip GCF_000001735.4_TAIR10.1_genomic.fna.gz 

ls

## Getting and unzipping the file was pretty easy.

# TASK 3 - Unix tools

## Q1 - How many sequences are in the FASTA file?

grep -i ">" GCF_000001735.4_TAIR10.1_genomic.fna -c

## Q2 - What is the total number of nucleotides (not including header lines or newlines)?

grep -i ">" GCF_000001735.4_TAIR10.1_genomic.fna -v | tr -d "\n" | wc -m

## Q3 - How many total lines are in the file?

cat GCF_000001735.4_TAIR10.1_genomic.fna | wc -l

## Q4 - How many header lines contain the word "mitochondrion"?

grep -i ">" GCF_000001735.4_TAIR10.1_genomic.fna | grep "mitochondrion" -c

## Q5 - How many header lines contain the word "chromosome"?

grep -i ">" GCF_000001735.4_TAIR10.1_genomic.fna | grep "chromosome" -c

## Q6 - How many nucleotides are in each of the first 3 chromosome sequences?

head GCF_000001735.4_TAIR10.1_genomic.fna -n 2 | tail -n 1 | wc -m

head GCF_000001735.4_TAIR10.1_genomic.fna -n 4 | tail -n 1 | wc -m

head GCF_000001735.4_TAIR10.1_genomic.fna -n 6 | tail -n 1 | wc -m

paste <(head GCF_000001735.4_TAIR10.1_genomic.fna -n 2 | tail -n 1 | wc -m) <(head GCF_000001735.4_TAIR10.1_genomic.fna -n 4 | tail -n 1 | wc -m) <(head GCF_000001735.4_TAIR10.1_genomic.fna -n 6 | tail -n 1 | wc -m)

## Q7 - How many nucleotides are in the sequence for 'chromosome 5'?

grep -A 1 "chromosome 5" GCF_000001735.4_TAIR10.1_genomic.fna | tail -n 1 | wc -m

## Q8 - How many sequences contain "AAAAAAAAAAAAAAAA"?

grep -i ">" GCF_000001735.4_TAIR10.1_genomic.fna -v | grep "AAAAAAAAAAAAAAAA" | wc -l

## Q9 - If you were to sort the sequences alphabetically, which sequence (header) would be first in that list?

grep -i ">" GCF_000001735.4_TAIR10.1_genomic.fna | sort | head -n 1

## Q10 - How would you make a new tab-separated version of this file, where the first column is the headers and the second column are the associated sequences?

paste <(grep -i ">" GCF_000001735.4_TAIR10.1_genomic.fna) <(grep -i ">" GCF_000001735.4_TAIR10.1_genomic.fna -v) > new_tsv.txt

## Everytime I tried to view this output, my computer would crash. So I asked ChatGPT if it could help with making a command to see the first few characters of each row in the two columns.

awk -F'\t' -v OFS='\t' '{print substr($1,1,100), substr($2,1,100)}' new_tsv.txt | column -ts $'\t' | less -S

## I believe this is looking into each of the columns and showing the first 100 characters. This helped confirm my command was working. I also had to delete this file (new_tsv.txt) before I could push to git, because it was so big.

# TASK 5 - Reflection

## Overall, this assignment was straightforward. It started off simple with creating the assignment architecture and downloading the FASTA file. When I got to Task 3, I felt pretty confident from what we learned in class, especially using the grep command. I reminded myself of the possible parameters by using the –help argument for grep, tr, tail, and wc, as those were the commands I knew I would have to use the most. I wasn’t extremely familiar with all the possible arguments and functionalities they had, so the –help command was super helpful. For me, grep was by far the most powerful for the questions for this assignment, especially since the FASTA file format is clean and information is separated line by line. It was smooth sailing until I got to question 10 and I couldn’t see my output. I knew I had the correct logic to split up the file based on header and non-header lines and use the paste command to align them column wise, but I didn’t know how to truncate the output. I kept trying different combinations of the head command, but my computer just kept crashing when I tried anything. I ended up asking ChatGPT if it could give me a command that would give me the first 100 characters of my two columns and it showed me that my paste command worked perfectly. The truncating command used awk, which I have used in the past in my previous research experiences, but am not very comfortable with it. I can easily tell how important this skillset is for computational biology, because it made parsing through huge files so easy. I can’t imagine opening these kinds of files on a text editor and having to manually search for particular sequences or headers. The modularity of the unix command line tools especially when using pipe streamlines the analysis process significantly. I believe I did a good job of making my README.md easy to turn into a script, as long as you add #!/bin/bash to the top line of a blank script and have a ~/BIOCOMPUTING/assignments/ directory. If you copy and paste all the lines from this README.md into that script and make it executable, it should replicate my work entirely. You shouldn’t have to worry about the random text as I commented everything out using Hashtags. 

## Side note: Actually, fixing this git after trying to push the fasta files was so confusing and painful. I had to beg ChatGPT to help me.
