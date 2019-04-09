#!/bin/bash

groupmod -u $GID $UNAME
usermod -u $UID $UNAME
chown $UID.$GID -R /.seafile
chown $UID.$GID -R /.supervisord
chown $UID.$GID -R /volume
chown $UID.$GID /entrypoint.sh
chown $UID.$GID /infinite-seaf-cli-start.sh
