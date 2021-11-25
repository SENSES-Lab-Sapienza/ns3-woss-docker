# ns-3 & WOSS Docker images

[ns-3][ns3] and [WOSS][woss] bundles using [Docker][docker].

The scope of this repository is to automate the installation process of both 
ns-3 and WOSS library, in order to provide a hassle-free setup process for a 
simulation environment.

Images ship with fully-functioning ns-3 and WOSS library installations, also 
including the corresponding woss-ns3 module. 
ns-3 is provided already built in `debug` and `optimized` profiles, with the 
former being the active version on a first run; utility scripts to quickly
switch between them are provided (see below).
Database configuration is left to the user, mainly for Docker image size 
purposes.

## Available configurations

| OS | ns-3 | WOSS | Docker image | Dockerfile |
| :---: | :---: | :---: | :---: | :---: |
| Ubuntu 18.04 | [3.33][ns3.33] | [1.12.0][woss-changelog] | [`egiona/ns3-woss:u18.04-n3.33-w1.12.0`][image1] | [link][file1] |
| Ubuntu 18.04 | [3.33][ns3.33] | [1.12.1][woss-changelog] | [`egiona/ns3-woss:u18.04-n3.33-w1.12.1`][image2] | [link][file2] |
| Ubuntu 18.04 | [3.34][ns3.34] | [1.12.1][woss-changelog] | [`egiona/ns3-woss:u18.04-n3.34-w1.12.1`][image3] | [link][file3] |
| Ubuntu 18.04 | [3.34][ns3.34] | [1.12.2][woss-changelog] | [`egiona/ns3-woss:u18.04-n3.34-w1.12.2`][image4] | [link][file4] |
| Ubuntu 18.04 | [3.35][ns3.35] | [1.12.2][woss-changelog] | [`egiona/ns3-woss:u18.04-n3.35-w1.12.2`][image5] | [link][file5] |
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

&nbsp;&nbsp;&nbsp;&nbsp; _You can obtain a running container's ID using_&nbsp; `docker ps` _, or_&nbsp; `docker container ls -a` _for containers in any state._

## Optional instructions

> As long as you start the same container, any modification to its contents will be preserved.
However, it is advisable to keep a _local backup copy_ of your modules and experiment results.

1. Execute the utility script to download [WOSS (3.4 GB -> 8.2 GB)][woss-dbs] and [GEBCO 2020 (4.0 GB -> 7.5 GB)][gebco2020] databases _locally_ using

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `./download-databases.sh <DBs directory>`

&nbsp;&nbsp;&nbsp;&nbsp; _Were this utility to fail (or cannot be run due the lack of a UNIX-like system), download both databases via browser and use your favorite decompression tool on them._
<br/>
&nbsp;&nbsp;&nbsp;&nbsp; _More specifically, the extracted_&nbsp; `dbs` _directory should contain 4 sub-directories, namely:_&nbsp; `bathymetry`_,_ `seafloor_sediment`_,_ `ssp`_, and_&nbsp; `transducers`_._
<br/>
&nbsp;&nbsp;&nbsp;&nbsp; _Once extracted, place the_&nbsp; `GEBCO_2020.nc` _file under the_&nbsp; `dbs/bathymetry/` _sub-directory._

2. Copy an arbitrary local file into the container's filesystem using

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `docker cp <path/to/file> <container ID>:<desired/path/to/file>`

&nbsp;&nbsp;&nbsp;&nbsp; _Be sure to use_&nbsp; `/home/woss_reqs/` _as target container directory to copy the DBs directory into, then adapt ns-3 scripts to point to it._

3. Copy an arbitrary container's file to local filesystem using

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `docker cp <container ID>:<path/to/file> <local/path/to/file>`

4. You can switch between `debug` and `optimized` builds of ns-3 (see [details][ns3-builds]) using 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `./build-debug.sh` or `./build-optimized.sh` respectively 

&nbsp;&nbsp;&nbsp;&nbsp; _The aforementioned utility scripts are placed in directory_&nbsp; `/home/ns-allinone-3.xx/ns-3.xx/` _within a container's filesystem (replacing_&nbsp; `xx` _with your installed version of ns-3)._

5. Mount a local directory into a container (just once, instead of `docker run`) using

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `./mount <local/path/to/directory> <path/to/directory> <container name> <image name>`

&nbsp;&nbsp;&nbsp;&nbsp; _Local path to be mounted must be absolute. The path within a container's filesystem is placed under its_&nbsp; `/home/` _directory._
<br/>
&nbsp;&nbsp;&nbsp;&nbsp;_This is only needed the first time a container is instantiated, subsequent calls to_&nbsp; `docker start` _on the same container will automatically load the mounted directory._

# Citing this work

If you use any of the Docker images described in this repository, please cite this work using any of the following methods:

**APA**
```
Giona, E. ns-3 and WOSS Docker images [Computer software]. https://github.com/SENSES-Lab-Sapienza/ns3-woss-docker
```

**BibTex**
```
@software{Giona_ns-3_and_WOSS,
author = {Giona, Emanuele},
license = {MIT},
title = {{ns-3 and WOSS Docker images}},
url = {https://github.com/SENSES-Lab-Sapienza/ns3-woss-docker}
}
```

Bibliography entries generated using [Citation File Format][cff] described in the [CITATION.cff][citation] file.

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

[ns3.33]: https://www.nsnam.org/releases/ns-3-33/
[ns3.34]: https://www.nsnam.org/releases/ns-3-34/
[ns3.35]: https://www.nsnam.org/releases/ns-3-35/

[woss-changelog]: http://telecom.dei.unipd.it/ns/woss/doxygen/Changelog.html

[image1]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.33-w1.12.0
[file1]: ./u18.04-n3.33-w1.12.0/Dockerfile
[image2]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.33-w1.12.1
[file2]: ./u18.04-n3.33-w1.12.1/Dockerfile
[image3]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.34-w1.12.1
[file3]: ./u18.04-n3.34-w1.12.1/Dockerfile
[image4]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.34-w1.12.2
[file4]: ./u18.04-n3.34-w1.12.2/Dockerfile
[image5]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.35-w1.12.2
[file5]: ./u18.04-n3.35-w1.12.2/Dockerfile

[docker-hub-repo]: https://hub.docker.com/repository/docker/egiona/ns3-woss
[docker-install]: https://docs.docker.com/engine/install/

[woss-dbs]: http://telecom.dei.unipd.it/ns/woss/files/WOSS-dbs-v1.6.0.tar.gz
[gebco2020]: https://www.bodc.ac.uk/data/open_download/gebco/gebco_2020/zip/

[ns3-builds]: https://www.nsnam.org/docs/release/3.35/tutorial/html/getting-started.html#build-profiles

[cff]: https://citation-file-format.github.io/
[citation]: ./CITATION.cff

[docker-license]: ./LICENSE
[ns3-license]: https://www.nsnam.org/develop/contributing-code/licensing/
[woss-license]: http://telecom.dei.unipd.it/ns/woss/doxygen/License.html
