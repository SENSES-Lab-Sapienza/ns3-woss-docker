# ns-3 & WOSS Docker images

[ns-3][ns3] and [WOSS][woss] bundles using [Docker][docker].

The scope of this repository is to automate the installation process of both 
ns-3 and WOSS library, in order to provide a hassle-free setup process for a 
simulation environment.

## Available configurations

| OS | ns-3 | WOSS | Docker image | Dockerfile |
| :---: | :---: | :---: | :---: | :---: |
| Ubuntu 18.04 | 3.33 | 1.12.0 | N/A | [link][file1] |
<!--- | TBD | TDB | TDB | N/A | N/A | --->

All images can be found in the [Docker Hub repository][docker-hub-repo].

# Usage guidelines

## Core instructions

> The following instructions should apply to all platforms supported by Docker. 
However, _utility scripts_ are only provided for UNIX-like systems.

1. Install Docker (please refer to [official guidelines][docker-install] w.r.t. your own OS)

2. Select your desired Docker image according to the table above using

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `docker pull <image:tag>`

3. Launch a container using the selected image using 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `docker run -t -d --name <container name> <image name>`

4. Launch a live terminal from the container using 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `docker exec -it <container ID> /bin/bash`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _You can obtain a container's ID using_&nbsp; `docker ps`

## Optional instructions

> As long as you start the same container, any modification to its contents will be preserved.
However, it is advisable to keep a _local backup copy_ of your modules and experiment results.

1. Execute the utility script to download [WOSS (3.4 GB -> 8.2 GB)][woss-dbs] and [GEBCO 2020 (4.0 GB -> 7.5 GB)][gebco2020] databases _locally_ using

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `./download-databases.sh <DBs directory>`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _Were this utility to fail (or cannot be run due to not using a UNIX-like system), download both databases via browser and use your favorite decompression tool on them._
<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _More specifically, the extracted_&nbsp; `dbs` _directory should contain 4 sub-directories, namely:_&nbsp; `bathymetry`_,_ `seafloor_sediment`_,_ `ssp`_, and_&nbsp; `transducers`_._
<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _Once extracted, place the_&nbsp; `GEBCO_2020.nc` _file under the_&nbsp; `dbs/bathymetry/` _sub-directory._

2. Copy an arbitrary local file into the container's filesystem using

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `docker cp <path/to/file> <container ID>:<desired/path/to/file>`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _Be sure to use_&nbsp; `/home/woss_reqs/` _as target container directory to copy the DBs directory into, then adapt ns-3 scripts to point to it._
<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _Moreover, in order to correctly copy the databases directory_&nbsp; `dbs` _, you should add the_&nbsp; `-r` _(recursive) option to the_&nbsp; `docker cp` _command._

3. Copy an arbitrary container's file to local filesystem using

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `docker cp <container ID>:<path/to/file> <local/path/to/file>`

4. You can switch between `debug` and `optimized` builds of ns-3 (see [details][ns3-builds]) using 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `./build-debug.sh` or `./build-optimized.sh` respectively 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _The aforementioned utility scripts are placed in directory_&nbsp; `/home/ns-allinone-3.33/ns-3.33/` _within a container's filesystem._

# Citing this work

If you use any of the Docker images described in this repository, please cite this work using metadata described in the [CITATION.cff][citation] file.

# License

Copyright (c) 2021 Emanuele Giona (SENSES Lab, Sapienza University of Rome)

Docker images themselves are distributed under [MIT license][docker-license].
However, ns-3 and WOSS are distributed under their respective licenses:
[ns-3 license][ns3-license], [WOSS license][woss-license].
All installed packages may also be subject to their own license, and the license
chosen for the Docker images does not necessarily apply to them.



[ns3]: https://www.nsnam.org/
[woss]: http://telecom.dei.unipd.it/ns/woss/
[docker]: https://www.docker.com/
[file1]: ./u18.04-n3.33-w1.12.0/Dockerfile
[docker-hub-repo]: https://hub.docker.com/repository/docker/egiona/ns3-woss
[docker-install]: https://docs.docker.com/engine/install/
[woss-dbs]: http://telecom.dei.unipd.it/ns/woss/files/WOSS-dbs-v1.6.0.tar.gz
[gebco2020]: https://www.bodc.ac.uk/data/open_download/gebco/gebco_2020/zip/
[ns3-builds]: https://www.nsnam.org/docs/release/3.35/tutorial/html/getting-started.html#build-profiles
[citation]: ./CITATION.cff
[docker-license]: ./LICENSE
[ns3-license]: https://www.nsnam.org/develop/contributing-code/licensing/
[woss-license]: http://telecom.dei.unipd.it/ns/woss/doxygen/License.html
