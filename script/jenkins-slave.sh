#!/bin/bash

# Please note: This script must run after installing all software that the slave
# should provide. The install scripts will fill a file named ~/jenkins-labels with
# labels that describe the available software.
# Therefore, you only need to comment out unwanted install scripts. The labels
# of the slave will reflect your changes. There is no need to change this script!
#
# If you add a new install script, you must append a label to the file mentioned
# above. See e.g. 'nodejs.sh' for an example.

MASTER_IP=10.100.52.64
#MASTER_IP=0.0.0.0
PORT=8080
SLAVE_NAME="`cat ~vagrant/jenkins-name`"

# load labels from file and add fixed labels for platform etc.
FIXED_JENKINS_LABELS="linux ubuntu"
JENKINS_LABELS="$FIXED_JENKINS_LABELS `cat ~vagrant/jenkins-labels | tr '\n' ' '`"

mkdir -p $HOME/jenkins

# install swarm client
if [ ! -f $HOME/jenkins/swarm-client.jar ]
then
    swarmClientVersion=`curl -s http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/maven-metadata.xml | grep latest | sed 's/\s*[<>a-z/]//g'`
    wget --no-verbose -O $HOME/jenkins/swarm-client.jar http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/$swarmClientVersion/swarm-client-$swarmClientVersion-jar-with-dependencies.jar


cat <<INITD | sudo tee /etc/init.d/swarm-client
#! /bin/sh

### BEGIN INIT INFO
# Provides:        swarm-client
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:    \$remote_fs \$syslog
# Default-Start:    2 3 4 5
# Default-Stop:        0 1 6
# Short-Description:    Jenkins Swarm Client
### END INIT INFO

set -e

# /etc/init.d/swarm-client: start and stop the Jenkins Swarm Client daemon

test -e $HOME/jenkins/swarm-client.jar || exit 0

umask 022

if test -f $HOME/jenkins/swarm-client; then
  . $HOME/jenkins/swarm-client
fi

. /lib/lsb/init-functions

# Are we running from init?
run_by_init() {
  ([ "\$previous" ] && [ "\$runlevel" ]) || [ "\$runlevel" = S ]
}

check_dev_null() {
  if [ ! -c /dev/null ]; then
    if [ "\$1" = log_end_msg ]; then
      log_end_msg 1 || true
    fi
    if ! run_by_init; then
      log_action_msg "/dev/null is not a character device!" || true
    fi
    exit 1
  fi
}

case "\$1" in
  start)
    check_dev_null
    log_daemon_msg "Starting Jenkins Swarm Client" "swarm-client" || true
    if [ -f $HOME/jenkins/swarm-client.jar ]
    then
      cd ~vagrant
      echo "Purging workspace directory"
      rm -rf workspace
      echo "Starting Jenkins slave '$SLAVE_NAME' with these labels: $JENKINS_LABELS"
      sudo -u vagrant nohup java -Dfile.encoding=UTF-8 -jar $HOME/jenkins/swarm-client.jar -name $SLAVE_NAME -labels "$JENKINS_LABELS" -master http://$MASTER_IP:$PORT -executors 1 &
    else
      echo "Jar file '$HOME/jenkins/swarm-client.jar' not found: can't start swarm-client"
    fi
    ;;

  stop)
    log_daemon_msg "Stop not supported" "swarm-client" || true
    ;;

  reload|force-reload)
    log_daemon_msg "Reload not supported" "swarm-client" || true
    ;;

  restart)
    log_daemon_msg "Restart not supported" "swarm-client" || true
    ;;

  try-restart)
    log_daemon_msg "Try-Restart not supported" "swarm-client" || true
    ;;

  status)
    log_daemon_msg "Status not supported" "swarm-client" || true
    ;;

  *)
    log_action_msg "Usage: /etc/init.d/swarm-client {start}" || true
    exit 1
esac

exit 0
INITD

# remove cr's to be sure script will execute
sudo sed -e "s/\r//g" /etc/init.d/swarm-client >/tmp/$$
sudo mv /tmp/$$ /etc/init.d/swarm-client
sudo chmod +x /etc/init.d/swarm-client
sudo update-rc.d swarm-client defaults
sudo update-rc.d swarm-client enable
fi

sudo service swarm-client start
