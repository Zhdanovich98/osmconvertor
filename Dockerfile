FROM centos:7

#ARG EXEC_USER=jdanovich
ARG ZLIB_URL="http://zlib.net/zlib-1.2.11.tar.gz"
ARG OSMCONVERT_SRC_URL="http://m.m.i24.cc/osmconvert.c"
ENV ZLIB_URL $ZLIB_URL
ENV OSMCONVERT_SRC_URL $OSMCONVERT_SRC_URL
#ENV EXEC_USER $EXEC_USER


RUN yum -y install make gcc

RUN curl -o /opt/zlib.tar.gz $ZLIB_URL && \
    cd /opt &&\
    tar zxf /opt/zlib.tar.gz && \
    rm /opt/zlib.tar.gz && \
    mv /opt/zlib* /opt/zlib && \
    cd /opt/zlib && \
    sed -i '1i#define _LARGEFILE64_SOURCE 1' zconf.h && \
    sed -i '1i#define _LFS64_LARGEFILE 1'  zconf.h && \
    sed -i '1i#define z_off64_t __int64' zconf.h && \
    ./configure && \
    make && \
    make install

RUN mkdir -p /opt/osmconvert
RUN curl -o /opt/osmconvert/osmconvert.c $OSMCONVERT_SRC_URL 
RUN gcc -x c -O3 -lz -o /opt/osmconvert/osmconvert /opt/osmconvert/osmconvert.c 
RUN ln -s /opt/osmconvert/osmconvert /usr/bin/osmconvert


CMD ["tail", "-f", "/dev/null"]
