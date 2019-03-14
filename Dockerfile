FROM debian:jessie

#ENV UID=1000
#ENV GID=1000
#RUN groupadd -g $GID -o seadrive
#RUN useradd -m -u $UID -g $GID -o -s /bin/bash seadrive

ENV DEBIAN_FRONTEND noninteractive

COPY assets/seafile.list /etc/apt/sources.list.d/
COPY assets/supervisord.conf /etc/supervisor/
COPY entrypoint.sh /

RUN apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 8756C4F765C9AC3CB6B85D62379CE192D401AB61
RUN apt-get update ;\
    apt-get install -o Dpkg::Options::="--force-confold" -y seafile-cli supervisor

RUN mkdir /seafile; mkdir /volume

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]