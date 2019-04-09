#!/bin/bash

if [ -z $UID ] && [ -z $GID ]; then
    groupadd -g $GID -o $UNAME ;\
    useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME ;\
    chown $UID.$GID -R /.seafile ;\
    chown $UID.$GID -R /.supervisord ;\
    chown $UID.$GID -R /volume ;\
    chown $UID.$GID /entrypoint.sh ;\
    chown $UID.$GID /infinite-seaf-cli-start.sh
else
    echo "\$UID and \$GID environment variables are required to update files ownership."
fi