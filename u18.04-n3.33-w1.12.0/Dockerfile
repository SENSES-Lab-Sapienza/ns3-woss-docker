# syntax=docker/dockerfile:1
FROM ubuntu:18.04

LABEL maintainer="giona.emanuele@gmail.com"
LABEL version="0.1"
LABEL description="Ubuntu 18.04 with ns-3.33 and WOSS 1.12.0"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y update && apt -y upgrade

# ===== ns-3 requirements =====
ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y install wget make

ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y install build-essential g++ python3 make wget && \
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

# ===== ns-3 source download & installation =====
RUN cd /home && mkdir downloads && cd downloads && \
 wget https://www.nsnam.org/releases/ns-allinone-3.33.tar.bz2 && \
 tar xjf ns-allinone-3.33.tar.bz2 && \
 mv ns-allinone-3.33 ../

# ===== WOSS requirements =====
ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir /home/woss && mkdir /home/woss_reqs && apt -y install gfortran unzip && cd /home/downloads && \
 wget http://telecom.dei.unipd.it/ns/woss/files/at.zip && \ 
 unzip at.zip && rm at/Makefile && mv at ../woss_reqs/ && \
 wget http://telecom.dei.unipd.it/ns/woss/files/hdf5-1.8.13.tar.gz && \
 tar -xf hdf5-1.8.13.tar.gz && mv hdf5-1.8.13 ../woss/ && \
 wget http://telecom.dei.unipd.it/ns/woss/files/netcdf-c-4.7.3.tar.gz && \
 tar -xf netcdf-c-4.7.3.tar.gz && mv netcdf-c-4.7.3 ../woss/ && \
 wget http://telecom.dei.unipd.it/ns/woss/files/netcdf-cxx4-4.3.1.tar.gz && \
 tar -xf netcdf-cxx4-4.3.1.tar.gz && mv netcdf-cxx4-4.3.1 ../woss/

COPY at/Makefile /home/woss/at/

RUN cd /home/woss_reqs/at && \
 make clean && make && \
 echo "export PATH=$PATH:/home/woss_reqs/at/Bellhop/" >> ~/.bashrc && \
 cd ../hdf5-1.8.13 && ./configure --enable-shared --prefix=/home/woss_reqs/ && \
 make && make install && \
 cd ../netcdf-c-4.7.3 && \
 ./configure --prefix=/home/woss_reqs --enable-netcdf-4 --enable-shared --disable-dap CPPFLAGS="$CPPFLAGS -I/home/woss_reqs/include" LDFLAGS="$LDFLAGS -L/home/woss_reqs/lib" && \
 make && make install && \
 cd ../netcdf-cxx4-4.3.1 && \
 ./configure --prefix=/home/woss_reqs --enable-shared CPPFLAGS="$CPPFLAGS -I/home/woss_reqs/include" LDFLAGS="$LDFLAGS -L/home/woss_reqs/lib" && \
 make && make install

# ===== WOSS source download & installation =====
ARG DEBIAN_FRONTEND=noninteractive
RUN cd /home/downloads && \
 wget https://github.com/signetlabdei/WOSS/archive/refs/tags/1.12.0.tar.gz && \
 tar -xf 1.12.0.tar.gz && \
 mv WOSS-1.12.0 ../woss/ && \
 wget https://github.com/MetalKnight/woss-ns3/archive/refs/tags/v1.12.0.tar.gz && \
 tar -xf v1.12.0.tar.gz && \
 mv woss-ns3-1.12.0 ../woss/ && \
 mkdir /home/woss_lib && cd /home/woss/WOSS-1.12.0 && ./autogen.sh && \
 ./configure --with-netcdf4=/home/woss_reqs --with-pthread --prefix=/home/woss_lib && \
 make && make install 

# ===== ns-3 builds with WOSS =====
# TODO

# ===== Cleanup =====
RUN rm -rf /home/downloads

CMD ["bash"]
