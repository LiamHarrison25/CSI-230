#!/bin/bash


#The purpose of this function is to output to the user that they have inputed an invalid option
function invalid_opt ()
{
	echo ""
	echo "Invalid Option"
	echo ""
	sleep 2

}

#The purpose of this function is to act as a main menu for the program, and allow the user to move to subsequent menus
function menu () 
{
	
	clear
	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice 
	
	case "$choice" in
		1) admin_menu
		;;
		
		2) security_menu
		;;
		
		3) exit 0
		;;
		
		*)
			invalid_opt
			
			menu
		;;
	esac
}

#The purpose of this function is to act as a menu for admin processes, and allow the user to use them
function admin_menu()
{
	clear
	echo "[L] list running processes"
	echo "[N] network sockets"
	echo "[V] VPN menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice
	
	case "$choice" in
		L|l) ps -ef |less
		;;
		N|n) netstat -an --inet |less
		;;
		V|v) vpn_menu
		;;
		4) exit 0
		;;
		*)
			invalid_opt
			admin_menu
		;;
	esac

admin_menu
}

#The purpose of this function is to act as a menu for editing the vpn. It allows for the user to easily edit the vpn. 
function vpn_menu() 
{
	clear
	echo "[A] add a peer"
	echo "[D] delete a peer"
	echo "[C] check if a user exists"
	echo "[B] back to admin menu"
	echo "[M] main menu"
	echo "[E] Exit"
	read -p "Please enter a choice above:" choice
	
	case "$choice" in
	A|a)
		bash peer.bash
		tail -6 wg0.conf |less
		;;
	D|d)
		read -p "please specify a user" user
		bash manage-users.bash -d -u ${user}
		read -p "press any button to proceed: " response
	;;
	B|b) admin_menu
	;;
	M|m) menu
	;;
	E|e) exit 0
	;;
	*)
		invalid_opt
		vpn_menu
	;;
	
	esac

vpn_menu

}

#The purpose of this function is to act as a menu for security. It allows the user to check security logs. 
function security_menu() 
{
	clear
	echo "[O] open network sockets"
	echo "[U] UID"
	echo "[C] check the last 10 logged in users"
	echo "[L] logged in users"
	echo "[B] back to main menu"
	echo "[E] Exit"
	read -p "please enter a choice above:" choice
	case "$choice" in
		O|o) netstat -1 |less
		;;
		U|u) cat /etc/passwd | grep "x:0" |less
		;;
		C|c) last -n 10 |less
		;;
		L|l) who |less
		;;
		E|e) exit 0
		;;
		B|b) menu
		;;
		*)
			invalid_opt
		;;
	esac

security_menu

}

menu

