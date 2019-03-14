#!/bin/bash

/usr/bin/seaf-cli init -c /ccnet -d /seafile
/usr/bin/seaf-cli start -c /ccnet
/usr/bin/seaf-cli sync -c /ccnet -u $USERNAME -p $PASSWORD -s $SERVER -l $LIBRARY_ID -d /volume
sleep 10
/usr/bin/supervisord