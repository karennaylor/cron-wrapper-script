#!/bin/sh

SCRIPTNAME="wrapper.sh"
MYSCRIPT="$1"
PIDFILE="/tmp/${SCRIPTNAME}-`echo ${MYSCRIPT} | sed 's/\//-/g'`.pid"

# It's important not to have two copies of the script running. 
if [ -f "${PIDFILE}" ]; then
   # Is the process is actually still running under this pid?
   OLDPID=`cat "${PIDFILE}"`
   RESULT=`ps -ef | grep ${OLDPID} | grep -v grep | grep "${MYSCRIPT}"`

   if [ -n "${RESULT}" ]; then
     # exit 0, because it's OK to find another instance.
     # we are exiting because we found a pid file and the process is still
     # running, so it isn't time to starte the script again yet.
     exit 0
   else
        echo "There was a PID left but no process was running.  Continuing anyway..."
   fi
fi

# Find process id of this script and update the pidfile
PID="$$"
echo ${PID} > "${PIDFILE}"

#call the script
"$1"

RETVAL="$?"
# if the script failed, return its exit status and exit
if [ ${RETVAL} -ne 0 ]; then
    echo -n "${RETVAL}" ; echo " was the exit status"
    exit 1 
fi

# We're done, remove the pidfile
if [ -f "${PIDFILE}" ]; then
    rm "${PIDFILE}"
fi

exit 0
