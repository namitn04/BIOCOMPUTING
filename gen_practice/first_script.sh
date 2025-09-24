#!/bin/bash

wget http://gzahn.github.io/binf-data-skills/Data/Chapter_3_Practice_Files.zip

unzip Chapter_3_Practice_Files.zip

cd Chapter_3_Practice_Files

paste A.txt B.txt > C.txt

head -n 6 C.txt

paste <(head -n 6 C.txt) <(grep -i "^[b,e]" words.txt) 

paste <(head -n 6 A.txt) <(cat story.txt | tr "." "\n" | head -n 6) 

cd ..

rm -rf Chapter_3_Practice_Files.zip
