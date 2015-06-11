#!/bin/sh

# Store name of jenkins slave
SLAVE_NAME=$1
if [ "$SLAVE_NAME" = "" ]
then
  SLAVE_NAME="`cat /etc/hostname`"
fi
echo "$SLAVE_NAME" > $HOME/jenkins-name

echo "Name of jenkins slave: $SLAVE_NAME"
