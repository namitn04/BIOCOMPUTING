# **Assignment 8 — Namit Nallapaneni**

**Date:** 11/23/25

This assignment examines the **fecal microbiota of L-DOPA–naive Parkinson’s disease (PD) patients** using sequence data from:

**Project ID:** PRJEB17784

The dataset contains two groups:

### **Parkinson’s Samples (PD)**

```
ERR1912976
ERR1913073
ERR1913059
ERR1912964
ERR1913119
```

### **Control Samples**

```
ERR1913016
ERR1913108
ERR1913060
ERR1913044
ERR1913110
```

---

## **QC and Annotation Parameters**

### **fastp parameters**

* `-l 100` (minimum read length 100 bp)
* `-e 10` (maximum expected error)

### **prokka parameters**

* `--evalue 1e-9` (more stringent annotation)

---

## **Coverage File Handling**

Coverage tables (`*.with_cov.tsv`) for each sample were collected using:

```
cp ~/scr10/assignment_08/mg_assembly_08/annotations/*/*.with_cov.tsv /sciclone/home/ncnallapaneni/BIOCOMPUTING/assignments/assignment_08/output/coverage/
```

Coverage files were renamed according to:

* `*_p_*` — Parkinson’s disease samples
* `*_c_*` — Control samples
* Each filename also includes `_fastp-l100-e10_prokka-eval1e9` to document pipeline metadata.

A final script was created (`final_cleanup.sh`) to automate and standardize these filename updates.

---

## **Notes**

ChatGPT was used to help generate the `final_cleanup.sh`.

I used this command to add my initials to the end of the coverage file names:

```
$for f in *with_cov.tsv; do     mv "$f" "${f/.with_cov.tsv/.with_cov.nn.tsv}"; done
```
