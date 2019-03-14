FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

COPY assets/seafile.list /etc/apt/sources.list.d/
COPY assets/supervisord.conf /
COPY entrypoint.sh /

RUN apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 8756C4F765C9AC3CB6B85D62379CE192D401AB61
RUN apt-get update ;\
    apt-get install -o Dpkg::Options::="--force-confold" -y seafile-cli supervisor

RUN mkdir /.seafile; mkdir /volume; touch supervisord.log

ENV UNAME=seafuser
ENV UID=1000
ENV GID=1000
RUN groupadd -g $GID -o $UNAME ;\
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME ;\
    chown $UID.$GID -R /.seafile ;\
    chown $UID.$GID -R /volume ;\
    chown $UID.$GID /supervisord.log ;\
    chown $UID.$GID /supervisord.conf
USER $UNAME

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]