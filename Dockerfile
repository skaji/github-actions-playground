ARG IMAGE
FROM $IMAGE
ARG IMAGE

RUN if [[ $IMAGE = centos:centos6 ]]; then sed -i 's/^#baseurl=/baseurl=/g; s/^mirrorlist=/#mirrorlist=/g; s/http:\/\/mirror.centos.org/https:\/\/vault.centos.org/g' /etc/yum.repos.d/CentOS-Base.repo; fi

RUN yum install -y \
    gcc \
    make \
    tar \
    curl \
    patch \
    xz
RUN mkdir -p \
    /lib \
    /lib/x86_64-linux-gnu \
    /lib64 \
    /usr/lib \
    /usr/lib/x86_64-linux-gnu \
    /usr/lib64 \
    /usr/local/lib \
    /usr/local/lib64
