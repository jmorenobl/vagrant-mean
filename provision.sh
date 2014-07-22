#!/bin/bash

NODEJS_NOT_INSTALLED=`which nodejs`
MONGODB_NOT_INSTALLED=`which mongodb`

if [ -z $NODEJS_NOT_INSTALLED ]; then
	# Update NodeJS in Ubuntu 10.04. The NodeJS version that comes by default is too old.
	apt-get install -y python-software-properties git-core
	add-apt-repository ppa:chris-lea/node.js
	apt-get update
	apt-get install -y nodejs
	npm install -g bower grunt-cli meanio@latest
fi

if [ -z $MONGODB_NOT_INSTALLED ]; then
	apt-get install -y curl
	cd /opt && curl -O http://downloads.mongodb.org/linux/mongodb-linux-x86_64-2.6.3.tgz
	tar -zxvf mongodb-linux-x86_64-2.6.3.tgz
	mkdir -p mongodb
	cp -R -n mongodb-linux-x86_64-2.6.3/* mongodb
	rm -rf mongodb-*
	
	MONGODB_EXECUTABLES=`ls mongodb/bin`
	for MONGODB_EXECUTABLE in $MONGODB_EXECUTABLES
	do
		ln -s /opt/mongodb/bin/$MONGODB_EXECUTABLE /usr/bin/$MONGODB_EXECUTABLE
	done

	mkdir -p /data/db

	echo "
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

nohup mongod &

exit 0
" > /etc/rc.local
	
	nohup mongod &
fi