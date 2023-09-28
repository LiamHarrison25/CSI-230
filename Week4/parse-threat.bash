#!bin/bash

#The goal of this program is to extract ips from emergingthreats.net and create a firewall

function DownloadBadIPs()
{
	wget http://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules	

	#gets the ips
egrep '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

}

fileName="badIPs.txt"

# Check for existing config file / if we want to override
if [[ -f "${fileName}" ]]
then 
	# Prompt if we need to overwrite the file
       	echo "The file badIPs.txt already exists."
	echo -n "Do you want to redownload the file? [y|N]"
	read to_overwrite

	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" || "${to_overwrite}" == "n"  ]]
	then
		echo "Using current badIPs.txt file" #uses the currently downloaded file
	
	elif [[ "${to_overwrite}" == "y" ]]
	then
		echo "Redownloading the badIps..." 
		
		#redownloads the file
		
		DownloadBadIPs
		
	# If they don't specify y/N then error
	else
		echo "Invalid value"
		exit 1
	fi
else
	echo "Downloading the badIPs..."
	
	#downloads the file
	
	DownloadBadIPs

fi


#switches for iptables, cisco, windows firewall, and Mac OS X. 

while getopts 'icmwp' OPTION ; do

	case "${OPTION}" in
	i|I) 
		#process iptables
		iptables=${OPTION}
	
	;;
	c|C)
		#cisco
		cisco=${OPTION}
		
	;;
	m|M)
		#Mac OS X
		macos=${OPTION}
		
	;;
	w|W)
		#Windows firewall
		windowsFirewall=${OPTION}
		
	;;
	p|P)
		#parse file
		parseFile=${OPTION}
		
	;;
	
	esac

done

#process iptables
if [[ ${iptables} ]]
then

	#firewall ruleset
	for eachIP in $(cat badIPs.txt)
		do
			#echo "block in from  ${eachIP} to any" | tee pf.conf

			echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables

		done
		
		clear
		echo "Created the IPtables for the firewall drop rules in the file badIPs.iptables"

fi

#cisco
if [[ ${cisco} ]]
then
	egrep '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' badIPs.txt | tee badIPs.nocidr
	
	for eachIP in $(cat badIPs.txt)
		do
			echo "deny IP host ${eachIP} any" | tee -a badIPs.cisco
		
		done
		rm badIps.nocidr
		clear
		echo "Created the IPtables for the firewall drop rules in the file badIPs.cisco"

fi

#macos
if [[ ${macos} ]]
then
	echo '
	scrub-anchor "com.apple/*"
	nat-anchor "com.apple/*"
	rdr-anchor "com.apple/*"
	dummynet-anchor "com.apple/*"
	anchor "com.apple/*"
	load anchor "com.apple" from "/etc/pf.anchors/com.apple"
	
	' | tee pf.conf
	
	for eachIP in $(cat pf.conf)
	do
		echo "block in from ${eachIP} to any" | tee -a pf.conf
	done
	clear
	echo "Created the IPtables for the firewall drop rules in the file pf.conf"

fi

#windowsFirewall
if [[ ${windowsFirewall} ]]
then
	egrep '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' badIPs.txt | tee badIPs.windowsForm
	
	for eachIP in $(cat badIPs.windowsForm)
	do
		echo "netsh advfirewall firewall add rule name=\"BLOCK IP ADDRESS - ${eachIP}\" dir=in action=block remoteip=${eachIP}" | tee -a badIPs.netsh
	done
	rm badIPs.windowsForm
	clear
	echo "Created the IPtables for the firewall drop rules in the file "

fi

#parseFile
if [[ ${parseFile} ]]
then
	wget http://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats/csv
	
	TODO: Grep and awk the domain entries, 
	
	
	clear
	echo "Created the IPtables for the firewall drop rules in the file "


fi


