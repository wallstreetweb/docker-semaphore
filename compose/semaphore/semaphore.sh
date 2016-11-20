#!/bin/bash

set -e 

if [ -z ${MYSQL_HOST+x} ]; then
    echo "No Default DB HOst Provided. Assuming Localhost"
    MYSQL_HOST="localhost"
fi

if [ -z ${MYSQL_PORT+x} ];then
    echo "No Default Port for DB provided. Assuming 3306."
    MYSQL_PORT="3306"
fi

if [ -z ${MYSQL_USER+x} ]; then
    echo "No DB User Provided. Assuming semaphore"
    MYSQL_USER="semaphore"
fi

if [ -z ${MYSQL_PASSWORD+x} ]; then
    echo "No DB Pass Provided. Assuming semaphore"
    MYSQL_PASSWORD="semaphore"
fi

if [ -z ${MYSQL_DATABASE+x} ]; then
    echo "No DB Name provided. Assuming semaphore"
    MYSQL_DATABASE="semaphore"
fi

if [ ! -d "/tmp/firstrun" ]; then
	echo "Creating Semaphore Configuration"
	echo "{\"mysql\":{\"host\": \"${MYSQL_HOST}:${MYSQL_PORT}\",\"user\": \"${MYSQL_USER}\",\"pass\": \"${MYSQL_PASSWORD}\",\"name\": \"${MYSQL_DATABASE}\"}}" > semaphore.config
	echo "${MYSQL_HOST}:${MYSQL_PORT}" >> /tmp/config_opts
	echo "${MYSQL_USER}"  >> /tmp/config_opts
	echo "${MYSQL_PASSWORD}" >> /tmp/config_opts
	echo "${MYSQL_DATABASE}" >> /tmp/config_opts
	echo "/home/webserver/semaphore" >> /tmp/config_opts
	echo "yes" >> /tmp/config_opts
	echo "semaphore" >> /tmp/config_opts
	echo "semaphore@local.host" >> /tmp/config_opts
	echo "Semaphore User" >>  /tmp/config_opts
	echo "semaphore" >> /tmp/config_opts

	echo "Applying migrations to the database."
	/usr/bin/semaphore -setup < /tmp/config_opts

	touch /tmp/firstrun
fi

/usr/bin/semaphore -config /home/webserver/semaphore.config
