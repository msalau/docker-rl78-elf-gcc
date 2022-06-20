# About

This is a docker image with GCC toolchain for Renesas RL78 microcontrollers.

The toolchain is build from sources from https://llvm-gcc-renesas.com/rl78/rl78-download-toolchains/

The current version is 4.9.2.202002

Build instructions: https://llvm-gcc-renesas.com/wiki/index.php?title=Building_the_RL78_Toolchain_under_Ubuntu_14.04

# Usage

Build a project using make:
```
docker run --rm -v "$(pwd):/src" msalau/rl78-elf-gcc make
```
Run the image in interactive mode:
```
docker run --rm -v "$(pwd):/src" -it msalau/rl78-elf-gcc
```

The version of the toolchain may be specified explicitly. E.g.:
```
docker run --rm -v "$(pwd):/src" -it msalau/rl78-elf-gcc:4.9.2.202002
```

# Pre-build toolchain

There is an option to use a pre-built toolchain from https://llvm-gcc-renesas.com

To make a docker image with it do the following:

1. Download a `run` file with GCC toolchain from https://llvm-gcc-renesas.com/rl78/rl78-download-toolchains/ into the folder:
2. Build an image with the compiler (replace `<image-name>` with a name of your choice and `<version>` with the version string of the toolchain, e.g.: `4.9.2.202201`):
```
docker build --build-arg VERSION=<version> -t <image-name> -f Dockerfile-bin .
```
3. Use it:
```
docker run --rm -v "$(pwd):/src" <image-name> make
```

# Details
The image is based on Ubuntu 16.04 x86_64.

Tools pre-installed in the image:
* make
* git
* srecord
* splint
* rl78-elf-gcc

The toolchain is installed into `/opt/rl78-elf-gcc` and is added to `PATH`.
There is no host compiler in the image.

# Source repository

https://github.com/msalau/docker-rl78-elf-gcc
