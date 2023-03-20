#!/bin/bash

# MIT License

# Copyright (c) 2023 Emanuele Giona <giona.emanuele@gmail.com> (SENSES Lab, 
# Sapienza University of Rome)

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

USAGE="Usage: ./$(basename "$0") </path/to/download_dir> </path/to/dbs_dir>
    where:
      - </path/to/download_dir> is the absolute path to the directory for downloading databases
      - </path/to/dbs_dir> is the absolute path to the directory for storing databases"

if [[ "$#" -ne 2 ]]; then
    echo "Invalid argument number."
    echo "${USAGE}"
    exit 1
fi

if [ ! -d "${1}" ]; then
    echo "Download directory does not exist."
    echo "${USAGE}"
    exit 1
fi

if [ ! -d "${2}" ]; then
    echo "Databse directory does not exist."
    echo "${USAGE}"
    exit 1
fi

CURR_DIR=`pwd`
WOSS_DBS=0
GEBCO_2020=0
GEBCO_2022=0

echo "Entering ${1}"
cd ${1}

echo "1/3: Downloading WOSS databases..."
wget http://telecom.dei.unipd.it/ns/woss/files/WOSS-dbs-v1.6.0.tar.gz && \
tar -xf WOSS-dbs-v1.6.0.tar.gz && \
rm WOSS-dbs-v1.6.0.tar.gz && \
let WOSS_DBS=1

if [ ${WOSS_DBS} -ne 1 ]; then
    echo "FAILED: exiting"
    exit 1
fi

echo "2/3: Downloading GEBCO 2020 database..."
curl -L -o gebco_2020_netcdf.zip https://www.bodc.ac.uk/data/open_download/gebco/gebco_2020/zip/ && \
unzip gebco_2020_netcdf.zip && \
rm gebco_2020_netcdf.zip && \
let GEBCO_2020=1

if [ ${GEBCO_2020} -ne 1 ]; then
    echo "FAILED: exiting"
    exit 1
fi

echo "3/3: Downloading GEBCO 2022 database..."
curl -L -o gebco_2022_netcdf.zip https://www.bodc.ac.uk/data/open_download/gebco/gebco_2022/zip/ && \
unzip gebco_2022_netcdf.zip && \
rm gebco_2022_netcdf.zip && \
let GEBCO_2022=1

if [ ${GEBCO_2022} -ne 1 ]; then
    echo "FAILED: exiting"
    exit 1
fi

echo "All databases downloaded"
echo "Moving WOSS databases to ${2}..."

cp -r --parents dbs/* ${2}/

if [ ! -d "${2}/dbs" ]; then
    echo "FAILED: exiting ('dbs' directory missing)"
    exit 1
fi

if [ ! -d "${2}/dbs/bathymetry" ]; then
    echo "FAILED: exiting ('dbs/bathymetry' directory missing)."
    exit 1
fi

echo "Moving GEBCO 2020 database..."
mv GEBCO_2020.nc ${2}/dbs/bathymetry/

echo "Moving GEBCO 2022 database..."
mv GEBCO_2022.nc ${2}/dbs/bathymetry/

cd ${CURR_DIR}

echo "Done"
echo "All databases moved to: ${2}/dbs/"
exit 0
