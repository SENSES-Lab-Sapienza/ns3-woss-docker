# Changelog

## Release v3.0.0

[Link to release][v300]

**Users are urged to update to any of the images hereby released.**

Introduced support to new OS, ns-3, and WOSS versions:

- OS: Ubuntu 20.04 LTS

- ns-3: 3.40

- WOSS: 1.12.5

Differently from previous releases, new images pair all supported ns-3 versions with WOSS 1.12.5.

This release fixes these critical issues:

- GCC version mismatch between WOSS requirements, WOSS library and ns-3

    Starting from ns-3.36, GCC 8 became the minimum supported version.
    More details can be found at [this page][gcc-8-issue]. 
    
    Images released prior to v3.0.0 bundled ns-3.37 with WOSS using Ubuntu 18.04 LTS as base image, causing the issue.
    Indeed, while ns-3 was being built with GCC 8, WOSS library and its dependencies were instead built and linked using the system-default GCC 7.5.0.
    During simulation execution, segmentation faults were occurring due such mismatch in GCC versions.

    In order to fix this issue, upgrading to Ubuntu 20.04 LTS is a quick solution since the system-default GCC version is 9.3.0.
    As a result, ns-3.37 images based on Ubuntu 18.04 should NOT be used, in favor of the hereby provided one, which is instead based on Ubuntu 20.04 LTS.

- Situational WOSS crashes (due to HDF5 and/or NetCDF-C)

    WOSS users designing simulations with long running time and/or large networks might encounter crashes from the NetCDF library.
    More details can be found at [this page][woss-netcdf-crash].

    In order to fix this issue, upgrading all WOSS requirements to their latest versions proved to be a solution to this problem.
    As a result, all images prior to v3.0.0 should NOT be used in case you encounter this problem during your WOSS-based simulations.

Minor changes:

- Instructions in each `Dockerfile` are re-arranged to reduce layers

## Release v2.0.1

[Link to release][v201]

Various updates to all supported images (revision `r2`):

- improved `Dockerfile` with: parametrized ns-3 and WOSS versions, separation of `debug` and `optimized` build directories

- uniformed functionality of scripts `build-debug.sh` and `build-optimized.sh` across ns-3 versions

- introduced utility `Makefile` to images released in v1.0.0

## Release v1.1.0

[Link to release][v110]

Introduced support to new ns-3 and WOSS versions:

- ns-3: 3.37

- WOSS: 1.12.4

ns-3 adopted the CMake build system starting from 3.36 release.

As a result, a new container filesystem has been designed, featuring separate ns-3 build directories depending on the profiles: `ns-3.37-debug` and `ns-3.37-optimized` directories respectively contain identical ns-3 source tree, permanently kept in their specific build profile.

More details can be found at [this page][ns3-cmake].

## Release v1.0.0

[Link to release][v100]

Initial release.

Supported versions:

- OS: Ubuntu 18.04 LTS

- ns-3: from 3.33 to 3.35

- WOSS: from 1.12.0 to 1.12.2



<!--- Releases --->
[v100]: https://github.com/SENSES-Lab-Sapienza/ns3-woss-docker/releases/tag/v1.0.0
[v110]: https://github.com/SENSES-Lab-Sapienza/ns3-woss-docker/releases/tag/v1.1.0
[v201]: https://github.com/SENSES-Lab-Sapienza/ns3-woss-docker/releases/tag/v2.0.1
[v300]: https://github.com/SENSES-Lab-Sapienza/ns3-woss-docker/releases/tag/v3.0.0

<!--- v1.1.0 --->
[ns3-cmake]: https://www.nsnam.org/docs/manual/html/working-with-cmake.html

<!--- v3.0.0 --->
[gcc-8-issue]: https://gitlab.com/nsnam/ns-3-dev/-/blob/ns-3.36/RELEASE_NOTES.md#release-336
[woss-netcdf-crash]: https://github.com/MetalKnight/woss-ns3/issues/43#event-10588536371
