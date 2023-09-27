#!bin/bash

#extracts ips from emergingthreats.net and creates a firewall

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
		echo "Using current badIPs.txt file"
	
	elif [[ "${to_overwrite}" == "y" ]]
	then
		echo "Redownloading the badIps..."
		
		wget http://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
		
	# If they don't specify y/N then error
	else
		echo "Invalid value"
		exit 1
	fi
fi


#gets the ips
egrep '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

#firewall ruleset
for eachIP in $(cat badIPs.txt)
do
	echo "block in from  $(eachIP) to any" | tee pf.conf
	
	#echo "iptables -A INPUT -s $(eachIP) -j DROP" | tee -a badIPS.iptables

done

#switches for iptables, cisco, windows firewall, and Mac OS X. 

function getopts()
{

while getopts 'hdau:c' OPTION ; do

	case "${OPTION}" in
	i|I) 
		#process iptables
		read -p "press any button to proceed: " response
	
	;;
	c|C)
		#cisco
	
		read -p "press any button to proceed: " response
	;;
	m|M)
		#Mac OS X
	
		read -p "press any button to proceed: " response
	;;
	w|W)
		#Windows firewall
	
		read -p "press any button to proceed: " response
	;;
	p|P)
		#parse file
		
		read -p "press any button to proceed: " response
	;;
	
	esac

done

}






