#!/bin/bash

# MIT License

# Copyright (c) 2021 Emanuele Giona <giona.emanuele@gmail.com> (SENSES Lab, 
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

NS3_DIR=/home/ns-allinone-3.33/ns-3.33
WOSS_LIB_SRC=/home/woss/WOSS-1.12.0
WOSS_LIB_DIR=/home/woss_lib/lib
WOSS_REQS_DIR=/home/woss_reqs

echo "Switching to optimized configuration in ns-3"

cd $NS3_DIR
./waf configure --with-woss-source=$WOSS_LIB_SRC --with-woss-library=$WOSS_LIB_DIR --with-netcdf4-install=$WOSS_REQS_DIR --build-profile=optimized --out=build/optimized --enable-examples --enable-tests CXXFLAGS="-Wall -Werror -Wno-unused-variable"
./waf build

echo "ns-3 build in use: optimized"
exit 0
