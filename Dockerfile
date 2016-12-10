FROM resin/rpi-raspbian 
MAINTAINER Jon Knoll

ENV BIND_USER=bind \
    BIND_VERSION=1:9.9.5 \
    WEBMIN_VER=1.820 \
    DATA_DIR=/data
RUN apt-get -o Acquire::GzipIndexes=false update && \
    apt-get install apt-show-versions && \
    apt-get install -y wget && \
    rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes && \
    apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl python && \
    wget http://prdownloads.sourceforge.net/webadmin/webmin_${WEBMIN_VER}_all.deb && \
    dpkg --install webmin_${WEBMIN_VER}_all.deb && \
    apt-get install -y bind9=${BIND_VERSION}* bind9-host=${BIND_VERSION}* && \
    rm -rf /var/lib/apt/lists/* 

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp
VOLUME ["${DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
