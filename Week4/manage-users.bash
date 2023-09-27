#!/bin/bash

#The purpose of this program is to allow for easy management of the VPN users. 

while getopts 'hdau:c' OPTION ; do

	case "$OPTION" in
		
		d) u_del=${OPTION}
		;;
		a) u_add=${OPTION}
		;;
		u) t_user=${OPTARG}
		;;
		h)
			echo ""
			echo "Help file:"
			echo ""
			echo "Usage: $(basename $0) [-a] | [-d] -u username"
			echo ""
			exit 1
		
		;;
		c) u_check=${OPTION}
		;;
		*)
			echo ""
			echo "Invalid Value"
			echo ""
			exit 1
		;;
	
	esac
	
done  

#Checks to see if both u_del and u_add are equal to nothing, or if they both are not. 
if [[ (${u_del} == "" && ${u_add} == "" && ${u_check} == "") || (${u_del} != "" && ${u_add} != "")]]
then 

	echo "Please specify either -a or -d and -u"

fi

#Checks to make sure that the user is specified
if [[ (${u_del} != "" || ${u_add} != "" || ${u_check} != "") && ${t_user} == "" ]]
then

	echo "Please specify the user"
	exit 1

fi

#Deletes the user from the server
if [[ $u_del ]]
then
	echo "Deleting user"
	sed -i "/# ${t_user} begin/,/# ${t_user} end/d" wg0.conf #removes the user from wg0.conf 

fi

#Adds the user to the server
if [[ $u_add ]]
then
	echo "Adding user"
	bash peer.bash ${t_user} # calls the peer.bash script to create the new user

fi

#Checks to see if the user exists
if [[ $u_check ]]
then
	result=$(cat wg0.conf | grep ${t_user})
	if [[$result != ""]]
	then
		echo "This user does exist in the wg0.conf"
	else
		echo "This user does not exist in the wg0.conf"
	fi
fi
