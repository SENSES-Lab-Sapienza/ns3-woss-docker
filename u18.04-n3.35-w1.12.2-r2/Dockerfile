# syntax=docker/dockerfile:1

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

FROM ubuntu:18.04

LABEL maintainer="giona.emanuele@gmail.com"
LABEL version="0.1"
LABEL description="Ubuntu 18.04 with ns-3.35 and WOSS 1.12.2"

ARG NS_ALLINONE="ns-allinone-3.35"
ARG NS_VER="ns-3.35"
ARG WOSS_VER="1.12.2"

# ===== Evinronment variables available in containers too =====
# Separate directories prevent from having CMake compile everything 
# from the start when switching between profiles
ENV NS3_DEBUG_DIR="/home/$NS_VER-debug"
ENV NS3_OPTIMIZED_DIR="/home/$NS_VER-optimized"

# Variable pointing at ns-3 dedicated Python 3 environment
ENV NS3_PY_ENV="/home/ns3-pyenv"

# WOSS-related variables
ENV WOSS_LIB_SRC="/home/woss/WOSS-$WOSS_VER"
ENV WOSS_LIB_DIR="/home/woss_lib"
ENV WOSS_REQS_DIR="/home/woss_reqs"

# ===== Basic OS updates =====
ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y update && apt -y upgrade

# ===== ns-3 requirements =====
RUN apt -y install make wget build-essential g++ python3 virtualenv apt-utils && \
 apt -y install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools && \
 apt -y install gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo python3-pygraphviz gir1.2-gtk-3.0 ipython3 && \
 apt -y install autoconf cvs bzr unrar && \
 apt -y install gdb valgrind && \
 apt -y install uncrustify && \
 apt -y install doxygen graphviz imagemagick && \
 apt -y install texlive texlive-extra-utils texlive-latex-extra texlive-font-utils dvipng latexmk && \
 apt -y install python3-sphinx dia && \
 apt -y install gsl-bin libgsl-dev libgslcblas0 && \
 apt -y install tcpdump && \
 apt -y install sqlite sqlite3 libsqlite3-dev && \
 apt -y install libxml2 libxml2-dev && \
 apt -y install cmake libc6-dev libc6-dev-i386 libclang-6.0-dev llvm-6.0-dev automake python3-pip && \
 pip3 install cxxfilt && \
 apt -y install libgtk-3-dev && \
 apt -y install vtun lxc uml-utilities && \
 apt -y install libxml2 libxml2-dev libboost-all-dev

# ===== ns-3 source download & installation directories setup =====
RUN cd /home && mkdir downloads && cd downloads && \
 wget "https://www.nsnam.org/releases/$NS_ALLINONE.tar.bz2" && \
 tar xjf "$NS_ALLINONE.tar.bz2" && \
 cp -R "$NS_ALLINONE/" ../ && mv ../"$NS_ALLINONE" "$NS3_DEBUG_DIR" && \
 cp -R "$NS_ALLINONE/" ../ && mv ../"$NS_ALLINONE" "$NS3_OPTIMIZED_DIR"

# ===== WOSS requirements =====
RUN mkdir /home/woss && mkdir "$WOSS_REQS_DIR" && apt -y install gfortran unzip && cd /home/downloads && \
 wget http://telecom.dei.unipd.it/ns/woss/files/at.zip && \ 
 unzip at.zip && rm at/Makefile && mv at ../woss_reqs/ && \
 wget http://telecom.dei.unipd.it/ns/woss/files/hdf5-1.8.13.tar.gz && \
 tar -xf hdf5-1.8.13.tar.gz && mv hdf5-1.8.13 ../woss/ && \
 wget http://telecom.dei.unipd.it/ns/woss/files/netcdf-c-4.7.3.tar.gz && \
 tar -xf netcdf-c-4.7.3.tar.gz && mv netcdf-c-4.7.3 ../woss/ && \
 wget http://telecom.dei.unipd.it/ns/woss/files/netcdf-cxx4-4.3.1.tar.gz && \
 tar -xf netcdf-cxx4-4.3.1.tar.gz && mv netcdf-cxx4-4.3.1 ../woss/

COPY at/Makefile "$WOSS_REQS_DIR/at/"

RUN cd "$WOSS_REQS_DIR/at" && \
 make clean && make && \
 echo "export PATH=$PATH:$WOSS_REQS_DIR/at/Bellhop/" >> ~/.bashrc && \
 cd /home/woss/hdf5-1.8.13 && ./configure --enable-shared --prefix="$WOSS_REQS_DIR" && \
 make && make install && \
 cd ../netcdf-c-4.7.3 && \
 ./configure --prefix="$WOSS_REQS_DIR" --enable-netcdf-4 --enable-shared --disable-dap CPPFLAGS="$CPPFLAGS -I$WOSS_REQS_DIR/include" LDFLAGS="$LDFLAGS -L$WOSS_REQS_DIR/lib" && \
 make && make install && \
 cd ../netcdf-cxx4-4.3.1 && \
 ./configure --prefix="$WOSS_REQS_DIR" --enable-shared CPPFLAGS="$CPPFLAGS -I$WOSS_REQS_DIR/include" LDFLAGS="$LDFLAGS -L$WOSS_REQS_DIR/lib" && \
 make && make install

# ===== WOSS source download & installation =====
RUN cd /home/downloads && \
 wget "https://github.com/signetlabdei/WOSS/archive/refs/tags/$WOSS_VER.tar.gz" && \
 tar -xf "$WOSS_VER.tar.gz" && \
 mv "WOSS-$WOSS_VER" ../woss/ && \
 wget "https://github.com/MetalKnight/woss-ns3/archive/refs/tags/v$WOSS_VER.tar.gz" && \
 tar -xf "v$WOSS_VER.tar.gz" && \
 mv "woss-ns3-$WOSS_VER" ../woss/ && \
 mkdir "$WOSS_LIB_DIR" && cd "$WOSS_LIB_SRC" && ./autogen.sh && \
 ./configure --with-netcdf4="$WOSS_REQS_DIR" --with-pthread --prefix="$WOSS_LIB_DIR" && \
 make && make install 

# ===== ns-3 Python 3 environment =====
RUN virtualenv --python=/usr/bin/python3 "$NS3_PY_ENV"

# ===== ns-3 builds with WOSS =====
ENV NS3_DEBUG_DIR="$NS3_DEBUG_DIR/$NS_VER"
ENV NS3_OPTIMIZED_DIR="$NS3_OPTIMIZED_DIR/$NS_VER"
ENV WOSS_LIB_DIR="/home/woss_lib/lib"
ENV CXX_CONFIG="-Wall -Werror -Wno-unused-variable"

COPY ns3-build/* ns3-utils/* /home/
RUN cd /home && \
 cp -R "/home/woss/woss-ns3-$WOSS_VER/" "$NS3_DEBUG_DIR/src/" && \
 mv "$NS3_DEBUG_DIR/src/woss-ns3-$WOSS_VER" "$NS3_DEBUG_DIR/src/woss-ns3" && \
 chmod +x build-debug.sh && ./build-debug.sh && \
 cp -R "/home/woss/woss-ns3-$WOSS_VER/" "$NS3_OPTIMIZED_DIR/src/" && \
 mv "$NS3_OPTIMIZED_DIR/src/woss-ns3-$WOSS_VER" "$NS3_OPTIMIZED_DIR/src/woss-ns3" && \
 chmod +x build-optimized.sh && ./build-optimized.sh && \
 echo "" >> ~/.bashrc && \
 echo "# Automatic .bashrc reload and NS3 profile variable" >> ~/.bashrc && \
 echo "trap '. ~/.bashrc' USR1" >> ~/.bashrc && \
 echo 'export NS3_CURR_PROFILE=${NS3_DEBUG_DIR}' >> ~/.bashrc

# ===== Cleanup =====
RUN rm -rf /home/downloads

CMD ["/bin/bash"]
