#!/bin/bash

. /etc/rc.conf
. /etc/rc.d/functions

case "$1" in
  start)

    [ -d /var/run/courier ] || mkdir -p /var/run/courier
	chown courier:courier /var/run/courier
    
    if ck_daemon authdaemond; then
      echo "ERROR: authdaemond is not running"
      stat_fail
      exit 1
    fi

    stat_busy "Starting Courier webmaild"
    /usr/sbin/webmaild start
    if [ $? -gt 0 ]; then
      stat_fail
    else
      add_daemon webmaild
      stat_done
    fi
    ;;
  stop)
    stat_busy "Stopping Courier webmaild"
    /usr/sbin/webmaild stop > /dev/null
    if [ $? -gt 0 ]; then
      stat_fail
    else
      rm_daemon webmaild
      stat_done
    fi
    ;;
  restart)
    $0 stop
    sleep 1
    $0 start
    ;;
  *)
    echo "usage: $0 {start|stop|restart}"  
esac
exit 0
