FROM centos:7
LABEL maintainer=j.k.moore@sheffield.ac.uk


RUN yum install -y epel-release && \
    yum install -y python3 python3-pip Lmod curl wget git \
        bzip2 gzip tar zip unzip xz \
        patch make git which file \
        gcc-c++ perl-Data-Dumper perl-Thread-Queue \
         openssl-dev glibc-devel.i686 glibc-devel  libgcc.i686

RUN OS_DEPS='' && \
    test -n "${OS_DEPS}" && \
    yum --skip-broken install -y "${OS_DEPS}" || true

RUN yum clean all

RUN pip3 install -U pip setuptools && \
    hash -r pip3&& \
    pip3 install -U easybuild

RUN mkdir /app && \
    mkdir /scratch && \
    mkdir /scratch/tmp && \
    useradd -m -s /bin/bash easybuild && \
    chown easybuild:easybuild -R /app && \
    chown easybuild:easybuild -R /scratch

USER easybuild

RUN cd /scratch/tmp && wget https://www.mrc-bsu.cam.ac.uk/wp-content/uploads/2018/04/OpenBUGS-3.2.3.tar.gz  && tar -xvf OpenBUGS-3.2.3.tar.gz

RUN cd /scratch/tmp/OpenBUGS-3.2.3 && ./configure --prefix=/app && make -j $(nproc) && make install

RUN rm -rf /scratch/tmp/

CMD ["/bin/bash", "-l"]
