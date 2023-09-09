# ns-3 & WOSS Docker images

[ns-3][ns3] and [WOSS][woss] bundles using [Docker][docker].

The scope of this repository is to automate the installation process of both 
ns-3 and WOSS library, in order to provide a hassle-free setup process for a 
simulation environment.

Images ship with fully-functioning ns-3 and WOSS library installations, also 
including the corresponding [woss-ns3 module][woss-ns3]. 
ns-3 is provided pre-built in `debug` and `optimized` profiles, with the 
*former* being the active version on a first run; utility scripts to quickly
switch between them are provided (see below).
Database configuration is left to the user, mainly for Docker image size 
purposes.

## Available configurations *(latest first)*

Docker image name: [**`egiona/ns3-woss`**][docker-hub-repo].

| Docker image tag | OS | ns-3 | Build system | WOSS | Dockerfile |
| :---: | :---: | :---: | :---: | :---: | :---: |
| [`u18.04-n3.37-w1.12.4-r2`][image6] | Ubuntu 18.04 | [3.37][ns3.37] | CMake[^ns3-cmake] | [1.12.4][woss-changelog] | [link][file6] |
| [`u18.04-n3.35-w1.12.2-r2`][image5] | Ubuntu 18.04 | [3.35][ns3.35] | Waf | [1.12.2][woss-changelog] | [link][file5] |
| [`u18.04-n3.34-w1.12.2-r2`][image4] | Ubuntu 18.04 | [3.34][ns3.34] | Waf | [1.12.2][woss-changelog] | [link][file4] |
| [`u18.04-n3.34-w1.12.1-r2`][image3] | Ubuntu 18.04 | [3.34][ns3.34] | Waf | [1.12.1][woss-changelog] | [link][file3] |
| [`u18.04-n3.33-w1.12.1-r2`][image2] | Ubuntu 18.04 | [3.33][ns3.33] | Waf | [1.12.1][woss-changelog] | [link][file2] |
| [`u18.04-n3.33-w1.12.0-r2`][image1] | Ubuntu 18.04 | [3.33][ns3.33] | Waf | [1.12.0][woss-changelog] | [link][file1] |

[^ns3-cmake]: ns-3 adopted the CMake build system starting from 3.36 release. More details can be found at [this page](https://www.nsnam.org/docs/manual/html/working-with-cmake.html).

> New revisions of images (_i.e. `-rN` suffix_) **do not overwrite** previous ones in order to provide backwards compatibility.
Previous tags can still be found on [DockerHub][docker-hub-repo], but their use is discouraged.

# Usage guidelines

## Core instructions

> The following instructions should apply to all platforms supported by Docker. 
However, _utility scripts_ are only provided for UNIX-like systems.

1. Install Docker (please refer to [official guidelines][docker-install] w.r.t. your own OS)

2. Select your desired Docker image according to the table above using

    `docker pull egiona/ns3-woss:<tag>`

3. Retrieve the desired image identifier using 

    `docker images`

4. Launch a container using the selected image using 

    `docker run -td --name <container name> <image ID>`

5. Launch a live terminal from the container using 

    `docker exec -it <container ID or name> /bin/bash`

    _You can obtain a running container's ID using_&nbsp; `docker ps` _, or_&nbsp; `docker container ls -a` _(the latter also includes containers in any state)._

## Utility scripts

1. You can switch between `debug` and `optimized` builds of ns-3 (see [details][ns3-builds]) using 

    [`./build-debug.sh`][latest-debug] or [`./build-optimized.sh`][latest-optimized] respectively 

    The aforementioned utility scripts are placed in the directory `/home` of a container's filesystem (for `r2` and ns-3.37+ images).

    _Previous images stored them in directory_&nbsp; `/home/ns-allinone-3.xx/ns-3.xx/` _within a container's filesystem (replacing_&nbsp; `xx` _with your installed version of ns-3)._

2. Starting from ns-3.37+ images, as well as any new revision of previous ones, a utility script in the form of a [Makefile][latest-makefile] is provided.

    Similarly to [build scripts][latest-build], this utility Makefile is placed in the directory `/home` of a container's filesystem.

    _Previous revisions of images (apart from ns-3.37+) had no availability of such utility._

    This script allows for easy decoupling of development directory from ns-3's source directory.
    Indeed, it is possible to keep novel modules and program driver scripts outside `src` (or `contrib`) and `scratch` directories of the ns-3 installation directory during development, and only copying them afterwards.

    Multiple targets are present, allowing: ns-3 current version checking, compilation and execution of simulation driver programs (copying them to `scratch` subdir first), management of ns-3 modules (creation in `contrib` subdir and copy outside, synchronization of contents, elimination), and debugging (GNU debugger, Valgrind, ns-3 tests).

    Use the following command for all details:

    `make help`

## Optional instructions

> As long as you `restart` the same container, any modification to its contents will be preserved.
However, it is advisable to keep a _local backup copy_ of your modules and experiment results.

1. Execute the utility script to download [WOSS][woss-dbs], [GEBCO 2020][gebco2020], and [GEBCO 2022 2D 15 arc-seconds][gebco2022] databases _locally_ using

    `./download-databases.sh <DBs directory>`

    _Were this utility to fail (or cannot be run due the lack of a UNIX-like system), download both databases via browser and use your favorite decompression tool on them._

    _More specifically, the extracted_&nbsp; `dbs` _directory should contain 4 sub-directories, namely:_&nbsp; `bathymetry`_,_ `seafloor_sediment`_,_ `ssp`_, and_&nbsp; `transducers`_._

    _Once extracted, place the_&nbsp; `GEBCO_XXXX.nc` _file under the_&nbsp; `dbs/bathymetry/` _sub-directory._

2. Copy an arbitrary local file into the container's filesystem using

    `docker cp <path/to/file> <container ID>:<desired/path/to/file>`

    _Be sure to use_&nbsp; `/home/woss_reqs/` _as target container directory to copy the DBs directory into, then adapt ns-3 scripts to point to it._

3. Copy an arbitrary container's file to local filesystem using

    `docker cp <container ID>:<path/to/file> <local/path/to/file>`

4. Mount a local directory into a container (just once, instead of `docker run`) using

    `./mount.sh <local/path/to/directory> <path/to/directory> <container name> <image name>`

    _Local path to be mounted must be absolute. The path within a container's filesystem is placed under its_&nbsp; `/home/` _directory._

    _This is only needed the first time a container is instantiated, subsequent calls to_&nbsp; `docker start` _on the same container will automatically load the mounted directory._

5. Starting from `r2` images, an environment variables `CXX_CONFIG` is available for user-defined scripts to adapt their GCC compilation parameters; by default, such variable holds the following contents:

    `CXX_CONFIG="-Wall -Werror -Wno-unused-variable"`

    Moreover, [build scripts](./u18.04-n3.37-w1.12.4-r2/ns3-build/) have been updated to provide an exit value reflective of ns-3's configuration and build outcome.

# Citing this work

If you use any of the Docker images described in this repository, please cite this work using any of the following methods:

**APA**
```
Giona, E. ns-3 and WOSS Docker images [Computer software]. https://doi.org/10.5281/zenodo.5727519
```

**BibTeX**
```
@software{Giona_ns-3_and_WOSS,
author = {Giona, Emanuele},
doi = {10.5281/zenodo.5727519},
license = {MIT},
title = {{ns-3 and WOSS Docker images}},
url = {https://github.com/SENSES-Lab-Sapienza/ns3-woss-docker}
}
```

Bibliography entries generated using [Citation File Format][cff] described in the [CITATION.cff][citation] file.

# License

**Copyright (c) 2023 Emanuele Giona ([SENSES Lab][senseslab], Sapienza University of Rome)**

This repository and Docker images themselves are distributed under [MIT license][docker-license].

However, ns-3 and WOSS are distributed under their respective licenses:
[ns-3 license][ns3-license], [WOSS license][woss-license].
All installed packages may also be subject to their own license, and the license
chosen for the Docker images does not necessarily apply to them.

**Diclaimer: Docker, Ubuntu, ns-3, WOSS and other cited or included software belongs to their respective owners.**



[ns3]: https://www.nsnam.org/
[woss]: http://telecom.dei.unipd.it/ns/woss/
[docker]: https://www.docker.com/
[woss-ns3]: https://github.com/MetalKnight/woss-ns3

[docker-hub-repo]: https://hub.docker.com/r/egiona/ns3-woss

[ns3.33]: https://www.nsnam.org/releases/ns-3-33/
[ns3.34]: https://www.nsnam.org/releases/ns-3-34/
[ns3.35]: https://www.nsnam.org/releases/ns-3-35/
[ns3.37]: https://www.nsnam.org/releases/ns-3-37/

[woss-changelog]: http://telecom.dei.unipd.it/ns/woss/doxygen/Changelog.html

[latest-debug]: ./u18.04-n3.37-w1.12.4-r2/ns3-build/build-debug.sh
[latest-optimized]: ./u18.04-n3.37-w1.12.4-r2/ns3-build/build-optimized.sh
[latest-build]: ./u18.04-n3.37-w1.12.4-r2/ns3-build/
[latest-makefile]: ./u18.04-n3.37-w1.12.4-r2/ns3-utils/Makefile

[image6]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.37-w1.12.4-r2
[image5]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.35-w1.12.2-r2
[image4]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.34-w1.12.2-r2
[image3]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.34-w1.12.1-r2
[image2]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.33-w1.12.1-r2
[image1]: https://hub.docker.com/r/egiona/ns3-woss/tags?page=1&name=u18.04-n3.33-w1.12.0-r2
[file6]: ./u18.04-n3.37-w1.12.4-r2/Dockerfile
[file5]: ./u18.04-n3.35-w1.12.2-r2/Dockerfile
[file4]: ./u18.04-n3.34-w1.12.2-r2/Dockerfile
[file3]: ./u18.04-n3.34-w1.12.1-r2/Dockerfile
[file2]: ./u18.04-n3.33-w1.12.1-r2/Dockerfile
[file1]: ./u18.04-n3.33-w1.12.0-r2/Dockerfile

[docker-install]: https://docs.docker.com/engine/install/

[woss-dbs]: http://telecom.dei.unipd.it/ns/woss/files/WOSS-dbs-v1.6.0.tar.gz
[gebco2020]: https://www.bodc.ac.uk/data/open_download/gebco/gebco_2020/zip/
[gebco2022]: https://www.bodc.ac.uk/data/open_download/gebco/gebco_2022/zip/

[ns3-builds]: https://www.nsnam.org/docs/release/3.37/tutorial/html/getting-started.html#build-profiles

[cff]: https://citation-file-format.github.io/
[citation]: ./CITATION.cff

[senseslab]: https://senseslab.diag.uniroma1.it/
[docker-license]: ./LICENSE
[ns3-license]: https://www.nsnam.org/develop/contributing-code/licensing/
[woss-license]: http://telecom.dei.unipd.it/ns/woss/doxygen/License.html
