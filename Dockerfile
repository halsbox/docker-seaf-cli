FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /.seafile ;\
    mkdir /.supervisord ;\
    mkdir /volume

COPY assets/seafile.list /etc/apt/sources.list.d/
COPY assets/supervisord.conf /.supervisord/
COPY entrypoint.sh /

RUN apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 8756C4F765C9AC3CB6B85D62379CE192D401AB61
RUN apt-get update ;\
    apt-get install -o Dpkg::Options::="--force-confold" -y seafile-cli supervisor

ENV UNAME=seafuser
ENV UID=1000
ENV GID=1000
RUN groupadd -g $GID -o $UNAME ;\
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME ;\
    chown $UID.$GID -R /.seafile ;\
    chown $UID.$GID -R /.supervisord ;\
    chown $UID.$GID -R /volume
USER $UNAME

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]