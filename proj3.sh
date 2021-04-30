#!/bin/bash
# A program to display some system information
# Andy Heller-Jones
# ECE 2574 or something like that 
# 4/30/2021


menu=1
# @param $1 -- the string to print in between the bars
function printBars() { 
	echo "-------------------------"
	echo $1
	echo "-------------------------"
}

function continue() { 
	echo -n "Press [Enter] key to continue... "
	menu=1
	read
}

function printMenu() { 
	date
	printBars "Main Menu"
	echo "1. Operating system info"
	echo "2. Hostname and DNS info"
	echo "3. Network info"
	echo "4. Who is online"
	echo "5. Last logged in users"
	echo "6. My IP address"
	echo "7. My disk usage."
	echo "8. My home file-tree"
	echo "9. Exit"
	echo -n "Enter your choice [ 1 - 9]: "
}

while :
do 
	if [[ menu -eq 1 ]]; then 
		printMenu
		read nextMenu
		menu=0 # The next state is going to be to print some system info, so we toggle off of the menu state
	else 
		echo 
		case $nextMenu in 
		1) 
			printBars "System Information" 
			echo "Operating System : Linux"
			/usr/bin/lsb_release -a
			continue
		;;
		2) 
			printBars "Hostname and DNS information"
			echo "Hostname: "`hostname`
			echo "DNS domain : "`dnsdomainname`
			echo "FQDN: "`hostname --long`
			echo "Network Address (IP) : "`curl -s ifconfig.me`
			echo "DNS name servers (DNS IP) : "`sed -nr 's/nameserver (.*)/\1/p' /etc/resolv.conf`


			continue
		;;
		3) 
			printBars "Network information"
			echo "Total network interfaces found: "`ls -A /sys/class/net | wc -l`
			echo "*** IP Addresses Information ***"
			ifconfig
			echo
			echo "*** Network routing ***"
			netstat -rn
			echo
			echo "*** Interface traffic information***"
			netstat -i
			continue
		;;
		4) 
			printBars "Who is online"
			echo -e "NAME\t LINE\t\tTIME\tCOMMENT"
			who -s
			continue
		;;
	5) 
		printBars "List of last logged in users"
		lastlog | grep -v "**Never"
		continue
	;;
	6) 
		printBars "Public IP information"	
		curl -s ifconfig.me
		echo 
		continue
	;;
	7) 
		printBars "Disk Usage Info"
		df --output=pcent,source | grep -v tmpfs
		continue
	;;
	8)
		printBars "My home file-tree"
		./proj3script.sh 
		continue
	;;
	9)
		exit 0
	;;
	*) 
		echo 
		echo "Invalid number entered, try 1-9"
		echo 
		menu=1
	;;

	esac
	fi
done 

