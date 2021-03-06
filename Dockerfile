FROM ubuntu:16.04

LABEL Organization="CTFHUB" Author="Virink <virink@outlook.com>"

COPY _files /tmp

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list && \
    sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list && \
    sed -i '/security/d' /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get upgrade -y; \
    # netbase tcpdump socat
    apt-get install -y --no-install-recommends netbase tcpdump socat; \
    # lib
    apt-get install -y lib32ncurses5 lib32z1 lib32stdc++6; \
    # configure
    mv /tmp/flag.sh /flag.sh && \
    mv /tmp/start.sh /start.sh && \
    chmod +x /start.sh && \
    # pwn home dir
    useradd -U -m ctf && \
    mkdir -p /home/ctf && \
    # lib
    cp -R /lib* /home/ctf && \
    cp -R /usr/lib* /home/ctf; \
    # bin
    mkdir /home/ctf/bin && \
    cp /bin/sh /home/ctf/bin && \
    cp /bin/ls /home/ctf/bin && \
    cp /bin/cat /home/ctf/bin; \
    # pwn home dir permission
    chown -R root:ctf /home/ctf; \
    chmod -R 750 /home/ctf && \
    # dev
    mkdir /home/ctf/dev && \
    mknod /home/ctf/dev/null c 1 3 && \
    mknod /home/ctf/dev/zero c 1 5 && \
    mknod /home/ctf/dev/random c 1 8 && \
    mknod /home/ctf/dev/urandom c 1 9 && \
    chmod 666 /home/ctf/dev/*; \
    # clean
    apt-get clean && \
    # /var/lib/apt/lists/* 
    rm -rf /tmp/* /var/tmp/*;

WORKDIR /home/ctf

VOLUME /var/lib/tcpdump

EXPOSE 10000

CMD ["/start.sh"]