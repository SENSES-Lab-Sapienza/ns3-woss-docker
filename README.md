# ns-3 & WOSS Docker images

[ns-3][ns3] and [WOSS][woss] bundles using [Docker][docker].

The scope of this repository is to automate the installation process of both 
ns-3 and WOSS library, in order to provide a hassle-free setup process for a 
simulation environment.

The following configurations are provided:

| OS | ns-3 | WOSS | Docker image | Dockerfile |
| :---: | :---: | :---: | :---: | :---: |
| Ubuntu 18.04 | 3.33 | 1.12.0 | N/A | [link][file1] |
<!--- | TBD | TDB | TDB | N/A | N/A | --->

# Usage guidelines

> The following instructions should apply to all platforms supported by Docker. 
However, _utility scripts_ are only provided for UNIX-like systems.

`1` Install Docker (please refer to [official guidelines][docker-install] w.r.t. your own OS)

`2` Select your desired Docker image according to the table above using

 `docker pull <image:tag>`

`3` Launch a container using the selected image using 

`docker run -t -d --name <container name> <image name>`

`4` Launch a live terminal from the container using 

`docker exec -it <container ID> /bin/bash`

_You can obtain the container ID using_ `docker ps`

## Optional

> As long as you start the same container, new contents added will be preserved. 
It is thus advisable to keep a _local backup copy_ of your modules and experiment results.

`1` Execute the utility script to download WOSS (3.4 GB -> 8.2 GB) and GEBCO 2020 (4.0 GB -> 7.5 GB) databases _locally_ using

`./download-databases.sh <target directory>`

`2` Copy databases into the container's `/home/woss_reqs` directory using

`docker cp <DBs directory> <container ID>:/home/woss_reqs/`

_Be sure to use_ `/home/woss_reqs/` _as database directory for WOSS in scripts running inside a container._

# License

Docker images themselves are distributed under [MIT license][docker-license].
Author: Emanuele Giona.

However, ns-3 and WOSS are distributed under their respective licenses:
[ns-3 license][ns3-license], [WOSS license][woss-license].



[ns3]: https://www.nsnam.org/
[woss]: http://telecom.dei.unipd.it/ns/woss/
[docker]: https://www.docker.com/
[docker-license]: ./LICENSE
[ns3-license]: https://www.nsnam.org/develop/contributing-code/licensing/
[woss-license]: http://telecom.dei.unipd.it/ns/woss/doxygen/License.html
[file1]: ./u18.04-n3.33-w1.12.0/Dockerfile
[docker-install]: https://docs.docker.com/engine/install/
