#!/bin/bash

seafile_ini=~/.ccnet/seafile.ini
seafile_sock=/.seafile/seafile-data/seafile.sock
supervisord_conf=/.supervisord/supervisord.conf
supervisord_pid=/.supervisord/supervisord.pid
supervisord_log=/.supervisord/supervisord.log

/usr/bin/seaf-cli init -d /.seafile
while [ ! -f $seafile_ini ]; do sleep 1; done
/usr/bin/seaf-cli start
while [ ! -S $seafile_sock ]; do sleep 1; done
/usr/bin/seaf-cli sync -u $USERNAME -p $PASSWORD -s $SERVER -l $LIBRARY_ID -d /volume
/usr/bin/supervisord -u $UNAME -c $supervisord_conf -j $supervisord_pid -l $supervisord_log