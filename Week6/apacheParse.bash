#!/bin/bash

# Parse Apache logs

#Reads in file

APACHE_LOG="$1" #gets file from command line input

#Checks to make sure that the file exists
if [[ ! -f ${APACHE_LOG} ]]
then
	echo "Please specify the path to a log file"
	exit 1 
fi

# clean up logs
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \

# Look for web scanners

egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \

awk ' BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s\n"
	printf format, "IP", "Date", "Method", "Status", "Size", "URI"
	printf format, "--", "----", "------", "------", "----", "---"}

{ printf format, $1, $4, $6, $9, $10, $7}'


