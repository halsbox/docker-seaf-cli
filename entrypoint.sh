#!/bin/bash

/usr/bin/seaf-cli init -d /.seafile
while [ ! -f ~/.ccnet/seafile.ini ]; do sleep 1; done
/usr/bin/seaf-cli start
while [ ! -S /.seafile/seafile-data/seafile.sock ]; do sleep 1; done
/usr/bin/seaf-cli sync -u $USERNAME -p $PASSWORD -s $SERVER -l $LIBRARY_ID -d /volume
/usr/bin/supervisord -u $UNAME -c /.supervisord/supervisord.conf -p /.supervisord/supervisord.pid