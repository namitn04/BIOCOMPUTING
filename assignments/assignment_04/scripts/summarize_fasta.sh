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

#Sarah said -e works (goat)
