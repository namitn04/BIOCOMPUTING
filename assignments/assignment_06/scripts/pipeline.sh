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

