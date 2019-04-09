#!/bin/bash

groupadd -g $GID -o $UNAME ;\
useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME ;\
chown $UID.$GID -R /.seafile ;\
chown $UID.$GID -R /.supervisord ;\
chown $UID.$GID -R /volume ;\
chown $UID.$GID /entrypoint.sh ;\
chown $UID.$GID /infinite-seaf-cli-start.sh
