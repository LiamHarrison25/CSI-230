#!/bin/bash

#This script is used for local security checks

function checks()
{

if [[ $2 != $3 ]]
then

	echo -e "\e[1;31mThe $1 is not compliant. The current policy should be: $2.\e[0m"
	echo -e "\e[1;31mThe current value is: $3.\e[0m"
	echo -e "\e[1;31mRemediation: $4.\e[0m"
	echo ""

else
	
	echo -e "\e[1;32mThe $1 is compliant. Current Value $3.\e[0m"
	echo ""

fi
}



#password days checks---------------------------------------------------


#check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
# Check for password max
checks "Password Max Days" "365" "${pmax}" "change in /etc/login.defs"

#Checks the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' {print $2 } ')

#Check for password min
checks "Password Min Days" "14" "${pmin}" "change in /etc/login.defs"

#Checks the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' {print $2 } ')
checks "Password Warn Age" "7" "${pwarn}" "change in /etc/login.defs"


#misc checks---------------------------------------------------


#Check the SSH UsePam configuration
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 } ')
checks "SSH UsePAM" "yes" "${chkSSHPAM}" "change in /etc/login.defs"

# Check permissions on users home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ')
do

	chDir=$(ls -ld /home/${eachDir} | awk ' {print $1 } ')
	checks "Home Directory ${eachDir}" "drwx------" "${chDir}" "Run:\nchmod 700 /home/${eachDir}"

done

# Check IP forwarding is disables
pforw=$(egrep -i "net\.ipv4\.ip_forward" /etc/sysctl.conf /etc/sysctl.d/* | cut -d '=' -f 2 )
checks "Ip Forwarding " "0" "${pforw}" "change in net\.ipv4\.ip_forward"

# Check ICMP redirects are not accepted
picmp=$(egrep -i "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf | awk ' { print $3} ')
checks "ICMP redirects" "0" "${picmp}" "change in net\.ipv4\.conf\.all\.accept_redirects"


# cron checks---------------------------------------------------


# Check crontab is configured
pcrontab=$(stat /etc/crontab | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ')
checks "crontab permissions" "( 0/ root) ( 0/ root)" "${pcrontab}" "change in /etc/crontab"

# Check cron.hourly is configured
pcronhour=$(stat /etc/cron.hourly | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ')
checks "crontab hourly" "( 0/ root) ( 0/ root)" "${pcronhour}" "change in /etc/cron.hourly"

# Check cron.daily is configured
pcrondail=$(stat /etc/cron.daily | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ')
checks "crontab daily" "( 0/ root) ( 0/ root)" "${pcrondail}" "change in /etc/cron.daily"

# Check cron.weekly is configured
pcronweek=$(stat /etc/cron.weekly | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ')
checks "crontab weekly" "( 0/ root) ( 0/ root)" "${pcronweek}" "change in /etc/cron.weekly"

# Check cron.monthly is configured
pcronmont=$(stat /etc/cron.monthly | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ')
checks "crontab monthly" "( 0/ root) ( 0/ root)" "${pcronmont}" "change in /etc/cron.monthly"


# regular passwd, shadow, group, and gshadow checks ---------------------------------------------------


# Check passwd is configured
ppasswd=$(stat /etc/passwd | awk -F'[(/]' 'NR ==4 { print $2 } ')
ppasswd2=$(stat /etc/passwd | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ')
checks "passwd" "0644 ( 0/ root) ( 0/ root)" "${ppasswd} ${ppasswd2}" "change in /etc/passwd"

# Check shadow is configured
pshadow=$(stat /etc/shadow | awk -F'[(/]' 'NR ==4 { print $2} ')
pshadow2=$(stat /etc/shadow | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ')
checks "shadow" "0640 ( 0/ root) ( 42/ shadow)" "${pshadow} ${pshadow2}" "change in /etc/shadow"

# Check group is configured
pgroup=$(stat /etc/group | awk -F'[(/]' 'NR ==4 { print $2} ')
pgroup2=$(stat /etc/group | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "group" "0644 ( 0/ root) ( 0/ root)" "${pgroup} ${pgroup2}" "change in /etc/group"

# Check gshadow is configured
pgshadow=$(stat /etc/gshadow | awk -F'[(/]' 'NR ==4 { print $2 } ' )
pgshadow2=$(stat /etc/gshadow | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "gshadow" "0640 ( 0/ root) ( 42/ shadow)" "${pgshadow} ${pgshadow2}" "change in /etc/gshadow"


#passwd-, shadow-, group-, and gshadow- checks ---------------------------------------------------


# Check passwd- is configured
ppasswddash=$(stat /etc/passwd- | awk -F'[(/]' 'NR ==4 { print $2 } ')
ppasswddash=$(stat /etc/passwd- | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ')
checks "passwd-" "0644 ( 0/ root) ( 0/ root)" "${ppasswddash} ${ppasswddash2}" "change in /etc/passwd-"

# Check shadow- is configured
pshaddash=$(stat /etc/shadow- | awk -F'[(/]' 'NR ==4 { print $2} ')
pshaddash2=$(stat /etc/shadow- | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ')
checks "shadow-" "0640 ( 0/ root) ( 42/ shadow)" "${pshaddash} ${pshaddash2}" "change in /etc/shadow-"

# Check group- is configured
pgroupdash=$(stat /etc/group- | awk -F'[(/]' 'NR ==4 { print $2} ')
pgroupdash2=$(stat /etc/group- | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "group-" "0644 ( 0/ root) ( 0/ root)" "${pgroupdash} ${pgroupdash2}" "change in /etc/group-"

# Check gshadow- is configured
pgshaddash=$(stat /etc/gshadow- | awk -F'[(/]' 'NR ==4 { print $2 } ' )
pgshaddash2=$(stat /etc/gshadow- | awk 'NR ==4 { print $4,$5,$6,$8,$9,$10 } ' )
checks "gshadow-" "0640 ( 0/ root) ( 42/ shadow)" "${pgshaddash} ${pgshaddash2}" "change in /etc/gshadow-"


#legacy passwd, shadow, and group checks ---------------------------------------------------


# Check no legacy + entries in passwd
plegpasswd=$(grep '^+:' /etc/passwd)
checks "legacy passwd" "" "${plegpasswd}" "change in /etc/passwd"

# Check no legacy + entries in shadow
plegshad=$(grep '^+:' /etc/shadow )
checks "legacy shadow" "" "${plegshad}" "change in /etc/shadow"

# Check no legacy + entries in group
plegro=$(grep '^+:' /etc/group)
checks "legacy group" "" "${plegro}" "change in /etc/group"


#root id check ---------------------------------------------------


# Check root is the only UID 0 account
proot=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
checks "root UID 0 account" "root" "${proot}" "remove all other users that have a UID of 0. Do not remove root"

