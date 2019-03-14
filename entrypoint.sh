#!/bin/bash

# There's 5 second timeout to make sure the seafile deamon is properly initialised.

/usr/bin/seaf-cli init -d /.seafile
/usr/bin/seaf-cli start
sleep 5
/usr/bin/seaf-cli sync -u $USERNAME -p $PASSWORD -s $SERVER -l $LIBRARY_ID -d /volume
/usr/bin/supervisord -u $UID -c /supervisord.conf