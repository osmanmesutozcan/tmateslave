FROM ubuntu:16.04
MAINTAINER Osman Mesut OZCAN <osmanmesutozcan@gmail.com>


ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


RUN apt-get update && \
    apt-get install -y \
        git autoconf autogen pkg-config \
        m4 libtool libevent-dev perl \
        libncurses5-dev debhelper \
        libutempter-dev build-essential \
        wget unzip cmake libssl-dev \
        zlib1g-dev locales && \
\
        locale-gen en_US.UTF-8


RUN cd /tmp && \
    libssh_url="https://github.com/nviennot/libssh/archive/v0-7.zip" && \
    libssh_src_dir="/usr/src/libssh-git" && \
    libssh_zip="/tmp/v0-7.zip" && \
\
    wget ${libssh_url} && \
\
    unzip ${libssh_zip} -d /tmp/libssh && \
    mkdir ${libssh_src_dir} && cd ${libssh_src_dir} && \
    mv /tmp/libssh/libssh-0-7/* . && \
\
    mkdir -p build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DWITH_EXAMPLES=OFF -DWITH_SFTP=OFF .. && \
    make && \
    make install


RUN cd /tmp && \
    msgpack_src_dir="/usr/src/msgpack" && \
    msgpack_url="https://github.com/msgpack/msgpack-c/releases/download/cpp-1.3.0/msgpack-1.3.0.tar.gz" && \
    msgpack_tar="/tmp/msgpack-1.3.0.tar.gz" && \
    msgpack_sum="b539c9aa1bbe728b9c43bfae7120353461793fa007363aae8e4bb8297948b4b7" && \
\
    wget ${msgpack_url} && \
    chmod 0644 ${msgpack_tar} && \
    test `sha256sum ${msgpack_tar} | cut -d " " -f 1` = ${msgpack_sum} && \
\
    mkdir ${msgpack_src_dir} && \
    tar zxf ${msgpack_tar} --strip-components 1 -C ${msgpack_src_dir} && \
\
    cd ${msgpack_src_dir} && \
    ./configure --prefix=/usr/ && \
    make && \
    make install


RUN git clone https://github.com/tmate-io/tmate-slave.git /code
WORKDIR /code


RUN ./create_keys.sh && \
    ./autogen.sh && \
    ./configure && \
    make


RUN apt-get remove -y \
        autoconf autogen git pkg-config \
        build-essential libtool m4 perl \
        wget unzip cmake


ENTRYPOINT ['/code/tmate-slave']
