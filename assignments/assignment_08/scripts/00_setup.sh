#!/bin/bash

set -ueo pipefail

# build out data and output structure in scratch directory

## set scratch space for data
SCR_DIR="${HOME}/scr10/assignment_08" # change to main writeable scratch space if not on W&M HPC, I changed the path so that it is a lil cleaner

## set project directory in scratch space
PROJECT_DIR="${SCR_DIR}/mg_assembly_08"

## set database directory
DB_DIR="${SCR_DIR}/db"

## make directories for this project
mkdir -p "${PROJECT_DIR}/data/raw"
mkdir -p "${PROJECT_DIR}/data/clean"
mkdir -p "${PROJECT_DIR}/output"
mkdir -p "${DB_DIR}/metaphlan"
mkdir -p "${DB_DIR}/prokka"
