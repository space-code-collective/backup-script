#!/bin/bash
# backup script

if [[ -s "backup.config" ]]; then
  source "backup.config"
else
  echo "fatal: no config file found"
  exit 1
fi

# check if target directory exists
if [[ ! -d "${targetDirectory}" ]]; then
  echo "fatal: target directory does not exists"
  exit 1
fi

# check if backup directory exists
if [[ ! -d "${targetDirectory}" ]]; then
  echo "fatal: target directory does not exists"
  exit 1
fi

targetDirectoryName=$(echo "${targetDirectory}" | sed 's:.*/::')

# check if target directory is empty
if [[ -z "$(ls -A ${targetDirectory})" ]]; then
  echo "error: refuse to backup directory which is empty"
fi

# progress info
echo "info: backing up..."

# make shadow copy of target directory
nice -n 19 cp -r "${targetDirectory}" "/tmp/"
# move shadow copy to tmp dir
nice -n 19 mv "/tmp/${targetDirectoryName}" "/tmp/backup"

# remember current directory
pwd=$(pwd)
cd /tmp/

# compress
echo "info: compressing..."

nice -n 19 tar -czf "backup.tar.gz" "backup"

echo "info : done compressing"

nice -n 19 rm -r "backup"
nice -n 19 mv "backup.tar.gz" "${timestampFormat}-backup.tar.gz"
nice -n 19 mv "${timestampFormat}-backup.tar.gz" "${backupDirectory}"

# finish info
echo "info: backup successful"

# get back to were we were
cd "${pwd}"
