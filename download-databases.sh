#!/bin/bash

# MIT License

# Copyright (c) 2021 Emanuele Giona <giona.emanuele@gmail.com> (SENSES Lab)

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

cd $1

echo "Downloading databases"

wget http://telecom.dei.unipd.it/ns/woss/files/WOSS-dbs-v1.6.0.tar.gz
tar -xf WOSS-dbs-v1.6.0.tar.gz
rm WOSS-dbs-v1.6.0.tar.gz
wget https://www.bodc.ac.uk/data/open_download/gebco/gebco_2020/zip/
unzip gebco_2020_netcdf.zip
rm gebco_2020_netcdf.zip
mv gebco_2020_netcdf/GEBCO_2020.nc dbs/bethymetry/

echo "Databases downloaded at directory: $1/dbs/"
exit 0
