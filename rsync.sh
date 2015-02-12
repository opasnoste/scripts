#!/bin/sh

SOURCE=$1
TARGET=$2
PORT=$3
SSHLOGIN=$4
SSHPASS=$5

while true
do
  rsync -avz --rsh="/usr/bin/sshpass -p ${SSHPASS} ssh -l ${SSHLOGIN} -p${PORT}" --progress --partial ${SOURCE} ${TARGET}
  res=$?
  if [ ${res} -eq 0 ];then break;fi
  sleep 30
done
