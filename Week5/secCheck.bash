#!/bin/bash

#This script is used for local security checks

function checks()
{

if [[ $2 != $3 ]]
then

	echo -e "\e[1;31mThe $1 is not compliant. The current policy should be: $2.\e[0m"
	echo -e "\e[1;31mThe current value is: $3.\e[0m"

else

	echo -e "\e[1;32mThe $1 is compliant. Current Value $3.\e[0m"

fi
}


#check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
# Check for password max
checks "Password Max Days" "365" "${pmax}"

#Checks the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' {print $2 } ')
#Check for password min
checks "Password Min Days" "14" "${pmin}"

#Checks the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' {print $2 } ')
checks "Password Warn Age" "7" "${pwarn}"

#Check the SSH UsePam configuration
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "${chkSSHPAM}"

# Check permissions on users home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' {print $3 } ')
do

	chDir=$(ls - ld /home/${eachDir} | awk ' {print $1 } ')
	checks "Home Directory ${eachDir}" "drwx------" "${chDir}"

done

# Check IP forwarding is disables
pforw=$(egrep -i "net\.ipv4\.ip_forward" /etc/sysctl.conf /etc/sysctl.d/* | awk ' { print $1 } ')
checks "Ip Forwarding " "0" "${pforw}"

# Check ICMP redirects are not accepted
picmp=$(egrep -i "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf | awk ' { print $1} ')
checks "ICMP redirects" "0" "${picmp}"

# Check crontab is configured
pcrontab=$(egrep -i "Access: (0700/--------) Uid: ()" stat /etc/crontab | awk ' { print $1} ')
checks "crontab permissions" "0" "${pcrontab}"

# Check cron.hourly is configured
pcronhour=$(egrep "Access: (0700/-------)  Uid: ()" stat /etc/cron.hourly | awk ' { print $1} ')
checks "crontab hourly" "/0" "${pcronhour}"

# Check cron.daily is configured
pcrondail=$(egrep "Access: (0700/-------)  Uid: ()" stat /etc/cron.daily | awk ' { print $1} ')
checks "crontab daily" "/0" "${pcrondail}"

# Check cron.weekly is configured
pcronweek=$(egrep "Access: (0700/-------)  Uid: ()" stat /etc/cron.weekly | awk ' { print $1} ')
checks "crontab weekly" "/0" "${pcronweek}"

# Check cron.monthly is configured
pcronmont=$(egrep "Access: (0700/-------)  Uid: ()" stat /etc/cron.monthly | awk ' { print $1} ')
checks "crontab monthly" "/0" "${pcronmont}"

# Check passwd is configured
ppasswd=$(egrep "Access: (0700/-------)  Uid: ()" stat /etc/passwd | awk ' { print $1} ')
checks "passwd" "0" "${ppasswd}"

# Check shadow is configured
pshadow=$(egrep "Access: (0700/-------)  Uid: ()" stat /etc/shadow | awk ' { print $1} ')
checks "shadow" "0" "${pshadow}"

# Check group is configured
pgroup=$(egrep "Access: (0700/-------)  Uid: ()" stat /etc/group | awk ' { print $1} ')
checks "group" "0" "${pgroup}"

# Check gshadow is configured
pgshadow=$(egrep "Access: (0700/-------)  Uid: ()" stat /etc/gshadow | awk ' { print $1} ')
checks "gshadow" "0" "${pgshadow}"

# Check no legacy + entries in passwd
plegpass=$(grep '^\+:' /etc/passwd | awk ' { print $1} ')
checks "legacy entries in passwd" "0" "${plegpass}"

# Check no legacy + entries in shadow
plegshad=$(grep '^\+:' /etc/shadow | awk ' { print $1} ')
checks "legacy entries in shadow" "0" "${plegshad}"

# Check no legacy + entries in group
pleggro=$(grep '^\+:' /etc/group | awk ' { print $1} ')
checks "legacy entries in group" "0" "${pleggro}"

# Check root is the only UID 0 account
proot=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
checks "root UID 0 account" "0" "${proot}"

