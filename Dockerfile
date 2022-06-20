FROM ubuntu:16.04 as builder

ENV PATH=${PATH}:/opt/rl78-elf-gcc/bin TZ=UTC

RUN set -x \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
        build-essential \
        libgmp-dev \
        libmpfr-dev \
        libmpc-dev \
        libncurses5-dev \
        texinfo \
        flex \
        bison \
        file \
        patch \
        unzip \
        wget \
        ca-certificates

RUN set -x \
    && mkdir -p /ws \
    && cd /ws \
    && wget "https://llvm-gcc-renesas.com/downloads/d.php?f=rl78/binutils/4.9.2.202002/binutils_rl78_2.24_2020q2.zip" -O binutils.zip \
    && wget "https://llvm-gcc-renesas.com/downloads/d.php?f=rl78/gcc/4.9.2.202002/gcc_rl78_4.9.2_2020q2.zip" -O gcc.zip \
    && wget "https://llvm-gcc-renesas.com/downloads/d.php?f=rl78/newlib/4.9.2.202002/newlib_rl78_3.1.0_2020q2.zip" -O newlib.zip \
    && wget "https://llvm-gcc-renesas.com/downloads/d.php?f=rl78/gdb/4.9.2.202002/gdb_rl78_7.8.2_2020q2.zip" -O gdb.zip \
    && unzip -q ./binutils.zip \
    && unzip -q ./gcc.zip \
    && unzip -q ./newlib.zip \
    && unzip -q ./gdb.zip \
    && chmod -R +x ./binutils \
    && chmod -R +x ./gcc \
    && chmod -R +x ./newlib \
    && chmod -R +x ./gdb

RUN set -x \
    && cd /ws \
    && mkdir build-binutils \
    && cd build-binutils \
    && ../binutils/configure --target=rl78-elf --prefix=/opt/rl78-elf-gcc --disable-nls --disable-werror \
    && make \
    && make install

RUN set -x \
    && cd /ws \
    && mkdir build-gcc \
    && cd build-gcc \
    && ../gcc/configure --target=rl78-elf --prefix=/opt/rl78-elf-gcc --disable-nls --disable-werror --enable-languages=c,c++ --disable-shared --enable-lto --with-newlib \
    && make all-gcc \
    && make install-gcc

RUN set -x \
    && cd /ws \
    && mkdir build-newlib \
    && cd build-newlib \
    && ../newlib/configure --target=rl78-elf --prefix=/opt/rl78-elf-gcc --disable-nls --disable-werror \
    && make \
    && make install

RUN set -x \
    && cd /ws \
    && cd build-gcc \
    && make \
    && make install

RUN set -x \
    && cd /ws \
    && mkdir build-gdb \
    && cd build-gdb \
    && ../gdb/configure --target=rl78-elf --prefix=/opt/rl78-elf-gcc --disable-nls --disable-werror \
    && make \
    && make install

FROM ubuntu:16.04

COPY --from=builder \
    /opt/rl78-elf-gcc \
    /opt/rl78-elf-gcc

RUN set -x \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
        make \
        git \
        srecord \
        splint \
        libgmp10 \
        libmpc3 \
        libmpfr4 \
        libncurses5 \
    && mkdir /src \
    && apt-get clean \
    && rm -rf m -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH=${PATH}:/opt/rl78-elf-gcc/bin

VOLUME /src
WORKDIR /src
