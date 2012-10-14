#!/bin/bash

if [ `whoami` != "root" ]
then
	echo "You need to be root to run this."
	exit
fi

START=$(date +%s)

#You can save all of your variables in this rc file
#May be a bit easier to manage across multiple subnets
if [ -f ~/.od-autoassessrc ]
then
	. ~/.od-autoassessrc
fi

#source bashrc because of msfconsole issues and rvm (aliasing issues)
. ~/.bashrc

DO="0"

for i in "$@"
do

	if [ "$DO" ]
	then
	
		if [ ! "$CLNT" ]
		then
			CLNT=`echo "$i" | grep "^\-\-client=" | sed "s/--client=//"`
		fi

		if [ ! "$RANGE" ]
		then
			RANGE=`echo "$i" | grep "^\-\-range=" | sed "s/--range=//"`
		fi
	
		if [ ! "$CMPNY" ]
		then
			CMPNY=`echo "$i" | grep "^\-\-company\-name=" | sed "s/--company-name=//"`
		fi
		
		if [ ! "$LOGOPATH" ]
		then
			LOGOPATH=`echo "$i" | grep "^\-\-logo\-path=" | sed "s/--logo-path=//"`
		fi

		if [ ! "$OVASSERVER" ]
		then
			OVASSERVER=`echo "$i" | grep "^\-\-openvas\-server=" | sed "s/--openvas-server=//"`
		fi
	
		if [ ! "$OVASPORT" ]
		then
			OVASPORT=`echo "$i" | grep "^\-\-openvas\-port=" | sed "s/--openvas-port=//"` 
		fi
	
		if [ ! "$OVASUSER" ]
		then
			OVASUSER=`echo "$i" | grep "^\-\-openvas\-user=" | sed "s/--openvas-user=//"`
		fi

		if [ ! "$OVASPASS" ]
		then
			OVASPASS=`echo "$i" | grep "^\-\-openvas\-pass=" | sed "s/--openvas-pass=//"`
		fi

		if [ ! "$SINGLEHOST" ]
		then
			SINGLEHOST=`echo "$i" | grep "^\-\-single\-host=" | sed "s/--single-host=//"`
		fi

		if [ ! "$MSPLOITDRIVER" ]
		then
			MSPLOITDRIVER=`echo "$i" | grep "^\-\-metasploit\-sql\-driver=" | sed "s/--metasploit-sql-driver=//"`
		fi

		if [ ! "$MSPLOITCONN" ]
		then
			MSPLOITCONN=`echo "$i" | grep "^\-\-metasploit\-sql\-conn=" | sed "s/--metasploit-sql-conn=//"`
		fi

		if [ ! "$SENDTO" ]
		then
			SENDTO=`echo "$i" | grep "^\-\-send\-to=" | sed "s/--send-to=//"`
		fi

		if [ ! "$MBSAUSER" ]
		then
			MBSAUSER=`echo "$i" | grep "^\-\-mbsa\-user=" | sed "s/--mbsa-user=//"`
		fi

		if [ ! "$MBSAPASS" ]
		then
			MBSAPASS=`echo "$i" | grep "^\-\-mbsa\-pass=" | sed "s/--mbsa-pass=//"`
		fi

		if [ ! "$MBSAPATH" ]
		then
			MBSAPATH=`echo "$i" | grep "^\-\-mbsa\-remote\-path=" | sed "s/--mbsa-remote-path=//"`
		fi

		if [ ! "$RUNREMMBSA" ]
		then
			RUNREMMBSA=`echo "$i" | grep -x "^\-\-enable-mbsa"`
		fi

		if [ ! "$ISPROFILE" ]
		then
			ISPROFILE=`echo "$i" | grep -x "^\-\-profile\-only"`
		fi

		if [ ! "$DEBUG" ]
		then
			DEBUG=`echo "$i" | grep -x "^-\-\debug"`
		fi

		if [ ! "$STARTOVAS" ]
		then
			STARTOVAS=`echo "$i" | grep -x "^\-\-start\-openvassd"`
		fi

		if [ ! "$ISFOREIGN" ]
		then
			ISFOREIGN=`echo "$i" | grep -x "^\-\-foreign"`
		fi

		if [ ! "$PRINT" ]
		then
			PRINT=`echo "$i" | grep -x "^\-\-print"`
		fi

		if [ ! "$RUNW3AF" ]
		then
			RUNW3AF=`echo "$i" | grep -x "^\-\-enable\-w3af"`
		fi
	
		if [ ! "$TESTWEAKCREDS" ]
		then
			TESTWEAKCREDS=`echo "$i" | grep -x "^\-\-test\-weak\-credentials"`
		fi

		if [ ! "$RUNWAPITI" ]
		then
			RUNWAPITI=`echo "$i" | grep -x "^\-\-enable\-wapiti"`
		fi

		if [ ! "$RECORDPCAP" ]
		then
			RECORDPCAP=`echo "$i" | grep -x "^\-\-record\-packets"`
		fi

		if [ ! "$NEEDSHELP" ]
		then
			NEEDSHELP=`echo "$i" | grep -x "^\-\-help"`
		fi
		
		if [ ! "$UPDATE" ]
		then
			UPDATE=`echo "$i" | grep -x "^\-\-update\-tools"`
		fi
	fi

	DO="1"
done

if [ "$NEEDSHELP" ]
then
	echo "USAGE: sh od-autoassess.sh [OPTIONS]\n\n"
	echo "Example:#sh od-autoassess.sh --client=jdoe --range=192.168.0.0/24 --profile-only\n"
	echo "Options:"
	echo "\t--profile-only\t\tOnly profile the network, run no vulnerability assessments and create no reports. Requires --client and --range."
	echo "\t--client\t\tName of the client whose network is being scanned."
	echo "\t--range\t\t\tIP range to be scanned."
	echo "\t--company-name\t\tName that you would like the PDF reports created with."
	echo "\t--logo-path\t\tPath to the logo you want to customize reports with. Requires --company-name"
	echo "\t--openvas-server\tIP address to a remote (or local) server for openvassd."
	echo "\t--openvas-port\t\tPort which openvassd will be listening on."
	echo "\t--openvas-user\t\tUsername for openvassd server."
	echo "\t--openvas-pass\t\tPassword for openvassd server."
	echo "\t--single-host\t\tSingle host to scan."
	echo "\t--metasploit-sql-driver\tDatabase driver to use for metasploit. Options are 'mysql', 'postgresql', 'sqlite3' (UNSTABLE)."
	echo "\t--metasploit-sql-conn\tConnection string to the SQL database if using MySQL or PostgreSQL."
	echo "\t--mbsa-user\t\tUser to log in as on remote machine when running MBSA."
	echo "\t--mbsa-pass\t\tPassword for the user on the remote machine when running MBSA."
	echo "\t--mbsa-remote-path\tRemote path to MBSA on machines to be scanned."
	echo "\t--enable-mbsa\t\tEnable an MBSA scan on remote machines if applicable."
	echo "\t--send-to\t\tUsing the local machine as the mail server, send a copy of the scan archive to this email address."
	echo "\t--foreign\t\tHost running scan is foreign on the network. Host is removed from all scans and useful WAN information is collected."
	echo "\t--start-openvassd\tIf a local openvassd process is not running, attempt to start the server."
	echo "\t--enable-w3af\t\tEnable the web application framework assessment scans on computers with HTTP(s). Takes a long time, which is why it is *optional*"
	echo "\t--enable-wapiti\t\tWapiti acts like a fuzzer, injecting payloads to see if a script is vulnerable. Takes a long time, which is why it is *optional*"
	echo "\t--test-weak-credentials\tTest common services for weak username/password combinations. Takes a long time, which is why it is *optional*"
	echo "\t--debug\t\t\tIf something isn't working right, turn on debugging to see it's error."
	echo "\t--update-tools\t\tUpdate some of the tools' definitions. Nikto, OpenVAS, and Metasploit."
	echo "\t--record-packets\tRecord the packets for the duration of the scan. Useful for going back later."
	echo "\t--print\t\t\tPrint reports to the default printer. (WARNING: This could be a lot of paper! Seriously, 17 page single-host server reports)"
	echo "\t--help\t\t\tPrints this help."

	exit
fi

#get your current intranet IP
MYIP=`ifconfig | grep "inet addr:" | sed s/inet\ addr\:// | sed s/\ \ \ \ \ \ \ \ \ \ // | cut -f1 -d " " | sed '/127\.0\.0\.1/d'`

#current interface supplying us with internets
INETIF=`route | grep default | awk '{print $8}'`

if [ ! "$CLNT" ]
then
	echo "You need a client name for the scan."
	exit
fi

if [ "$RANGE" = "" ] -o [ "$SINGLEHOST" = "" ]
then
	echo "You need to give me an IP range or single host to work with."
	exit
fi

if [ "$RUNREMMBSA" ]
then
	if [ ! "$MBSAUSER" -o ! "$MBSAPASS" -o  ! "$MBSAPATH" ]
	then
		echo "You need to pass your MBSA remote credentials and path..."
		exit
	fi
fi

if [ "$ISPROFILE" = "" ]
then
	if [ ! "$OVASUSER" -o ! "$OVASPASS"]
	then
		echo "You need to specify a username and password for the vulnerability assessment server..."
		exit
	fi

	if [ ! "$MSPLOITDRIVER" ]
	then
		echo "You need to specify a Metasploit driver..."
		exit
	else
		if [ "$MSPLOITDRIVER" != "sqlite3" ]
		then
			if [ ! "$MSPLOITCONN" ]
			then
				echo "You need to specify a Metasploit connection string (w/ creds if need be)..."
				exit
			fi
		fi
	fi
fi

if [ ! "`type -a smbclient`" ]
then
	echo "You need to install smbclient..."
	exit
fi

if [ ! "`type -a arp-scan`" ]
then
	echo "You need to install arp-scan..."
	exit
fi

if [ ! "`type -a sslscan`" ]
then
	echo "You need in to install sslscan..."
	exit
fi

if [ ! "`type -a onesixtyone`" ]
then
	echo "You need to install onesixtyone..."
	exit
fi

if [ ! "`type -a nbtscan`" ]
then
	echo "You need to install nbtscan..."
	exit
fi

if [ ! "`type -a nmap`" ]
then
	echo "You need to install nmap..."
	exit
fi

if [ ! "`type -a traceroute`" ]
then
	echo "You need to install traceroute..."
	exit
fi

if [ "$TESTWEAKCREDS" ]
then
	if [ ! "`type -a hydra`" ]
	then
		echo "You need to install hydra..."
		exit
	fi
fi

if [ "$RUNW3AF" ]
then
	if [ ! "`type -a w3af_console`" ]
	then
		echo "You need to install w3af..."
		exit
	fi
fi

if [ "$RUNWAPITI" ]
then
	if [ ! "`type -a wapiti`" ]
	then
		echo "You need to install wapiti..."
		exit
	fi
fi

if [ ! "`type -a nikto`" ]
then
	echo "You need to install nikto..."
	exit
fi

if [ ! "`type -a zip`" ]
then
	echo "You need to install zip..."
	exit
fi

if [ "$RUNREMMBSA" ]
then
	if [ ! "`type -a winexe`" ]
	then
		echo "You need to install winexe..."
		exit
	fi
fi

if [ ! "$ISPROFILE" ]
then
	if [ ! "`type -a openvassd`" ]
	then
		echo "You need to install openvassd..."
		exit
	fi

	if [ ! "`type -a openvas-client`" ]
	then
		echo "You need to install openvas-client..."
		exit
	fi
	
	if [ ! "`type -a msfconsole`" ]
	then
		echo "You need to install msfconsole..."
		exit
	fi

	if [ ! "`type -a htmldoc`" ]
	then
		echo "You need to install htmldoc..."
		exit
	fi
fi

#redirect stderr so that no weird messages come up
if [ ! "$DEBUG" ]
then
	exec 3>&2 2> /dev/null
fi

clear

NMAPVER=`nmap --version | grep "^Nmap" | cut -d " " -f3`

IPLIST="network_ips"

#this is the folder where this script is located
SCRIPTSDIR=`readlink -f $0 | sed "s/$(basename $0)//"`

#date and time to the second
CLNTFLDR="$CLNT-`date +"%F-%R"`"



echo "Creating scan folder -> ~/scans/$CLNTFLDR"
mkdir -p ~/scans/"$CLNTFLDR"
cd ~/scans/"$CLNTFLDR"

if [ "$RECORDPCAP" ]
then
	FIFO=`echo "$RANDOM" | md5sum | cut -d " " -f1`
	mkfifo -m 655 /tmp/$FIFO

	echo "Recording packet session for the duration of the scan on interface $INETIF. THIS MEANS EVERYTHING!!!"
	tcpdump -i $INETIF -w session.pcap > /tmp/$FIFO &
	
	PCAPPID="$!"	
fi

if [ "$UPDATE" ]
then
	nikto -update
	openvas-nvt-sync
	msfupdate
fi

mkdir nmap smb nkt ssl snmp

if [ "$RUNREMMBSA" ]
then
	mkdir mbsa
fi

if [ "$RUNW3AF" ]
then
	mkdir w3af
fi

if [ "$RUNWAPITI" ]
then
	mkdir wapiti
fi

if [ "$ISFOREIGN" ]
then
	echo "\nSaving current WAN information to report..."
	WANIP=`wget -q -O - http://volatileminds.net/ip.php` #Don't worry, I am not spying on you. Simply returning a server variable, no more no less.
	echo "Current WAN IP: $WANIP\n" >> "$CLNT".rpt
	
	#make sure nothing funny is happening on the way to the internet
	traceroute google.com >> "$CLNT".rpt
	echo "\n" >> "$CLNT".rpt
	
	#see who this provider is, or other information related to the internet provider
	whois -H $WANIP > "$CLNT".whois
fi

if [ ! "$SINGLEHOST" ]
then
	echo "\nMapping network..."

	nmap -sP "$RANGE" | egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' > network_ips

	echo "\nRunning ARP scan over network...\n"
	arp-scan "$RANGE" > "$CLNT".arp

	ESCIP=`echo "$MYIP" | sed -e 's/[.]/\\\./g'`

	if [ "$ISFOREIGN" ]
	then
		sed '/'${ESCIP}'/d' network_ips > included
		IPLIST="included"
	fi
	
	echo "Total hosts found: `cat $IPLIST | wc -l`"
	
	echo "IP addresses found on the network:"
	cat $IPLIST

	echo "\nRunning NetBIOS scan..."
	nbtscan -r "$RANGE" > "$CLNT".nbt
	
	if [ "$ISFOREIGN" ]
	then
		sed "/$MYIP/d" "$CLNT".nbt > "$CLNT"_noforeign.nbt
		sed "/$MYIP/d" "$CLNT".arp > "$CLNT"_noforeign.arp
	fi
else
	echo "\nUsing $SINGLEHOST in single-host scan..."
	echo "$SINGLEHOST" > network_ips
fi

echo "\nScanning individual hosts..."

for i in `cat "$IPLIST"`
do
	echo "\n\tScanning $i..."
	nmap -sS -O $i > nmap/"$i".nmap

	#if [ `grep "Note: Host seems down." nmap/"$i".nmap` ] 	
	#then
	#	echo "\t  --Previously found host seems down, trying port scan again with different options..."
		
	#	echo "\n\nSeems host was down, trying again with -PN enabled...\n" >> nmap/"$i".nmap		
	#	nmap -ss -O -PN "$i" >> nmap/"$i".nmap
	#fi

	#make sure nothing funny is happening on the way to the host
	traceroute "$i" >> nmap/"$i".nmap

	ISFTP=`grep "^21/tcp" "nmap/$i.nmap"`
	ISHTTP=`grep "^80/tcp" "nmap/$i.nmap"`
	ISHTTPS=`grep "^443/tcp" "nmap/$i.nmap"`		
	ISSMB=`grep "^445/tcp" "nmap/$i.nmap"`
	ISSSH=`grep "^22/tcp" "nmap/$i.nmap"`
	ISSMTP=`grep "^25/tcp" "nmap/$i.nmap"`
	ISSNMP=`grep "^161/udp" "nmap/$i.nmap"`
	ISTRAP=`grep "^162/udp" "nmap/$i.nmap"` #not a trap, approved by ackbar

	if [ ! "$ISHTTP" ]
	then
		#tomcat
		ISHTTP=`grep "^8180/tcp" "nmap/$i.nmap"`
	fi

	if [ "$ISFTP" ]
	then
		if [ "$TESTWEAKCREDS" ]
		then
			echo "\t  --Testing for weak username/password combinations for FTP..."
			hydra -L "$SCRIPTSDIR"username.lst -P "$SCRIPTSDIR"password.lst $i ftp
		fi
	fi

	if [ "$ISSSH" ]
	then
		if [ "$TESTWEAKCREDS" ]
		then
			echo "\t  --Testing for weak username/password combinations for SSH..."
			hydra -L "$SCRIPTSDIR"username.lst -P "$SCRIPTSDIR"password.lst -S $i ssh2
		fi
		
		echo "\t  --Enumerating allowed SSL ciphers over port 22 (SSH)..." #sometimes I just wanna make this stuff sound cooler than it really is
		sslscan "$i":22 > ssl/"$i"_ssh.ssl
	fi

	if [ "$ISSMTP" ]
	then
		if [ "$TESTWEAKCREDS" ]
		then
			echo "\t --Testing for weak username/password combinations for SMTP..."
			hydra -L "$SCRIPTSDIR"username.lst -P "$SCRIPTSDIR"password.lst $i smtp-auth
		fi
	fi

	if [ "$ISHTTP" -o "$ISHTTPS" ]
	then
		echo "\t  --Searching for common web vulnerabilities..."

		#sometimes nikto asks if it can upload new information it finds
		#such as updated apache server headers and the like. I think
		#it is relatively harmless, but if you feel you don't want this
		#change the "n\r" to "y\r". There is also a config value you may 
		#set to this same effect. 
		echo "n\r" | nikto -h $i -o nkt/$i.html -Format html > /dev/null 

		if [ "$RUNW3AF" ]
		then
			echo "plugins" >> w3af/"$i.rc"
			echo "output console,htmlFile" >> w3af/"$i.rc"
			echo "output" >> "$CLNT.rc"
			echo "output config htmlFile" >> w3af/"$i.rc"
			echo "set verbosity 10" >> w3af/"$i.rc"
			echo "back" >> w3af/"$i.rc"
			echo "output config console" >> w3af/"$i.rc"
			echo "set verbosity 5" >> w3af/"$i.rc"
			echo "back" >> w3af/"$i.rc"
			echo "audit all" >> w3af/"$i.rc"
			echo "discovery webSpider,allowedMethods" >> w3af/"$i.rc"
			echo "discovery" >> w3af/"$i.rc"
			echo "back" >> w3af/"$i.rc"
			echo "target" >> w3af/"$i.rc"
				
			if [ "$ISHTTP" ]
			then
				echo "set target http://$i" >> w3af/"$i.rc"
			elif [ "$ISHTTPS" ]
			then
				echo "set target https://$i" >> w3af/"$i.rc"
			fi
			
			echo "back" >> w3af/"$i.rc"
			echo "start" >> w3af/"$i.rc"
			echo "exit" >> w3af/"$i.rc"
			
			echo "\t  --Performing web application framework assessment..." #this can take an hour for a base install of Drupal 7.
			
			W3AFRC=`readlink -f "w3af/$i.rc"`
			
			/usr/share/w3af/w3af_console -s "$W3AFRC"  > w3af/$i.w3af #so this is a bug in w3af_console in my opinion, it doesn't take relative paths (correctly).
		fi

		if [ "$ISHTTPS" ]
		then
			echo "\t  --Enumerating allowed SSL ciphers over port 443 (HTTPS)..."
			sslscan -dd -w 10 $i > ssl/"$i"_https.ssl
		
		elif [ "$ISHTTP" ]
		then
			if [ "$RUNWAPITI" ]
			then
				wapiti http://$i -v 1 > wapiti/$i.wpt
			fi
		fi
	fi

	if [ "$ISSMB" ]
	then
		#set the internal field separator for the time being
		#while loops will break if this isn't set
		IFS=$'\n'

		echo "\t  --Finding shared directories and drives..."
		smbclient -L "$i" -N > smb/"$i".smb

		#better way to do this? I hope so...
		SHARES=$(grep " Disk " smb/"$i".smb | sed 's/ Disk .*//g' | grep -v '\$' | sed 's/^[ \t]*//;s/[ \t]*$//')
		PRINTERS=$(grep " Printer " smb/"$i".smb | sed 's/ Printer .*//g' | grep -v '\$' | sed 's/^[ \t]*//;s/[ \t]*$//')		

		if [ "$SHARES" ]
		then
			echo $SHARES | while read s
			do
				echo -n "\t  --Attempting to get file list for public share: $s...\n"
				echo "\n\nAttempting to get file list for public share: $s" >> smb/"$i".smb
			 		
				smbclient "\\\\$i\\$s" -N -c "recurse;ls" >> smb/"$i".smb
			done
		fi
		
		if [ "$PRINTERS" ]
		then
			echo $PRINTERS | while read p
			do
				echo "\t  --Found public printer: $p"	
				
				echo "\nFound public printer on $i: $p" >> "$CLNT".rpt
			done
		fi

		if [ "$RUNREMMBSA" ]
		then
			#add domain support? I am sure it will be an issue later....
			echo "\t  --Running remote MBSA scan..."
			winexe --uninstall -U "$MBSAUSER"%"$MBSAPASS" //$i "$MBSAPATH" > mbsa/$i.mbsa
		fi
		
		#set IFS to default value
		unset IFS
	fi	

	if [ "$ISSNMP" -o "$ISTRAP" ]
	then
		echo "\t  --Running SNMP requests..."
		onesixtyone -w 10 -dd $i > "snmp/$i.snmp"
	fi

	for p in `cat nmap/"$i".nmap | grep '^[0-9]\{1,5\}/[tcp|udp]' | cut -f1 -d '/'`
	do
		ISUDP=`echo "$p" | grep '^[0-9]\{1,5\}/udp'`

		if [ "$ISUDP" ]
		then
        		SUSPICIOUS=`cat "$SCRIPTSDIR"suspicious_ports | grep "^$p (UDP)"`
		else
			SUSPICIOUS=`cat "$SCRIPTSDIR"suspicious_ports | grep "^$p " | grep -v "(UDP)"`
		fi
	
		INTERESTING=`cat "$SCRIPTSDIR"interesting_ports | grep "^$p "`

        	if [ "$SUSPICIOUS" ]
        	then
                	echo "\t  --Suspicious port found: $SUSPICIOUS"
			echo "Suspicious port found on $i: $SUSPICIOUS" >> "$CLNT.rpt"

			WASFUN="1"
        	fi

		if [ "$INTERESTING" ]
		then
			echo "\t  --Interesting port found: $INTERESTING"
			echo "Interesting port found on $i: $INTERESTING" >> "$CLNT.rpt"

			WASFUN="1"
		fi
	done
	
	if [ "$WASFUN" -eq "1" ]
	then
		#we had to insert some text, lets break up host information
		echo "\n" >> "$CLNT.rpt"
	fi
	
done

if [ ! "$ISPROFILE" ]
then
	mkdir reports/

	#set to exit on a failed command.
	#if a vulnerability scan fails to run, we don't want to keep going
	set -e

	echo "\n\nStarting vulnerability assessments."
	echo "Sleeping for 30 seconds, ctrl+c if you don't want this."
	sleep 30

	echo "\n\tConnecting to vulnerability scanner..."
	
	if [ ! "$OVASSERVER" ]
	then
		if [ "$STARTOVAS" ]
		then
			#this might fail if openvassd is already running and bound to 127.0.0.1, this is ok.
			set +e

			echo "\t  --Starting openvassd on 127.0.0.1..."
			openvassd -a 127.0.0.1 >> /dev/null
		
			set -e
		fi

		echo "\t  --Connecting to 127.0.0.1 since no server was specified..."
		echo "\t  --See --help if this is unintended."
		OVASSERVER="127.0.0.1"
		OVASPORT="9390" #this is the default port for the ubuntu builds I use, maybe different for your system
	fi

	echo "\n\t****************************************************"
	echo "\t*Running vulnerability assessment..."
	echo "\t**WARNING* This could break stuff."
	echo "\t*If stuffs hits the fan, it is your fault, not mine."
	echo "\t*This will take a while (hours for a 15+ network)."
	echo "\t*Go grab some coffee."
	echo "\t******************************************************"

	#HTMLFLDR=""

	if [ "$ISNESSUS" ]
	then
		nessus -q "$NSSSERVER" "$NSSPORT" "$NSSUSER" "$NSSPASS" "$IPLIST" reports/nessus_html -T html
		HTMLFLDR="nessus_html"
	else
		openvas-client -q "$OVASSERVER" "$OVASPORT" "$OVASUSER" "$OVASPASS" "$IPLIST" reports/openvas_html -T html_graph
		HTMLFLDR="openvas_html"
	fi

	echo "\n\tCreating next exploit assessment script...\n"
	touch "$CLNT.rc"
	echo "db_driver $MSPLOITDRIVER" >> "$CLNT.rc"

	if [ "$MSPLOITCONN" ]
	then
		echo "db_connect \"$MSPLOITCONN\"" >> "$CLNT.rc"
	else
		echo "\t  --WARNING: Using the sqlite3 db_driver is unsafe and may not work at all."
		echo "db_connect \"$CLNT.db\"" >> "$CLNT.rc"
	fi

	echo "db_workspace -a \"$CLNTFLDR\"" >> "$CLNT.rc"
	echo "db_nmap -iL $IPLIST" >> "$CLNT.rc"
	echo "setg AutoRunScript scraper" >> "$CLNT.rc"
	
	if [ "$NSSMSF" ]
	then
		echo "load nessus" >> "$CLNT.rc"
		echo "nessus_connect $NSSUSER:$NSSPASS@$NSSSERVER:$NSSPORT ok" >> "$CLNT.rc"
		#add scan code, this will be neat when done...
	fi
	
	echo "db_autopwn -t -e -p -r" >> "$CLNT.rc"
	echo "sessions -l -v" >> "$CLNT.rc"
	echo "sessions -K" >> "$CLNT.rc"
	echo "exit" >> "$CLNT.rc"
	
	echo "\tRunning next exploit assessment..."
	echo "\tThis can also take several minutes..."
	msfconsole -r "$CLNT.rc" > "$CLNT.msf"
	
	echo "\nCreating PDF reports for client..."

	if [ "$CMPNY" ]
	then  
	        sed -i 's/,<i> the Open Source security scanner.<\/i>//g' reports/"$HTMLFLDR"/index.html
	        sed -i "s/OpenVAS/$CMPNY/g" reports/"$HTMLFLDR"/index.html

		if [ "$SINGLEHOST" ]
		then
			sed -i "s/$SINGLEHOST/$CLNT/g" reports/"$HTMLFLDR"/index.html
		fi

	        if [ -z "$LOGOPATH" ]
	        then
	                htmldoc --webpage --no-links -t pdf14 -f reports/main.pdf "reports/$HTMLFLDR/index.html"
	        else
	                htmldoc --webpage --header l --logoimage "$LOGOPATH" --no-links -t pdf14 -f reports/main.pdf "reports/$HTMLFLDR/index.html"
	        fi      
	else
	        htmldoc --webpage --no-links -t pdf14 -f reports/main.pdf "reports/$HTMLFLDR/index.html"
	fi

	if [ "$PRINT" ]
	then
		mkdir reports/ps/
		pdftops reports/main.pdf reports/ps/main.ps
		lpr reports/ps/main.ps
	fi
	
	for i in `cat "$IPLIST"`
	do
	        CURIP=`echo $i | sed s/[.]/_/g`

		if [ "$SINGLEHOST" ]
		then
			sed -i "s/$SINGLEHOST/$CLNT/g" reports/$HTMLFLDR/$CURIP/index.html
		fi	

	        if [ "$CMPNY" ]
	        then
			sed -i 's/,<i> the Open Source security scanner.<\/i>//g' reports/$HTMLFLDR/$CURIP/index.html
			sed -i "/back to the list of ports/d" reports/$HTMLFLDR/$CURIP/index.html
	
                	sed -i "s/OpenVAS/$CMPNY/g" reports/$HTMLFLDR/$CURIP/index.html

	                if [ -z $LOGOPATH ]
	                then
	                        htmldoc --webpage --no-links -t pdf14 -f reports/$CURIP.pdf "reports/$HTMLFLDR/$CURIP/index.html"
	                else
	                        htmldoc --webpage --header l --logoimage "$LOGOPATH" --no-links -t pdf14 -f reports/$CURIP.pdf "reports/$HTMLFLDR/$CURIP/index.html"
	                fi
	        else
	                htmldoc --webpage --no-links -t pdf14 -f reports/$CURIP.pdf "reports/$HTMLFLDR/$CURIP/index.html"
	        fi

		if [ "$PRINT" ]
		then
			pdftops reports/$CURIP.pdf reports/ps/$CURIP.ps
			lpr reports/ps/$CURIP.ps
		fi
	done
	
	#now things can fail
	set +e
fi

echo "\n\n\nCreating ZIP archive of scan..."
cd ..
zip -r "$CLNTFLDR.zip" "$CLNTFLDR" >> /dev/null

END=$(date +%s)
TT=$(( $END - $START ))
MINS=$(( $TT / 60 ))
SECS=$(( $TT % 60 ))

echo "\n\nTotal time to analyze network:"
echo "$MINS minutes $SECS seconds\n"

echo "\n\nScanned `cat "$CLNTFLDR/$IPLIST" | wc -l` hosts in total in $MINS m $SECS s.\n\n" >> "$CLNTFLDR/$CLNT.rpt"

if [ "$SENDTO" ]
then
	echo "\nSending report to $SENDTO\n\n"
	
	(cat "$CLNTFLDR"/"$CLNT.rpt" 
	uuencode "$CLNTFLDR.zip" "$CLNTFLDR.zip"
	) | mail -s "Scan for $CLNT finished..." $SENDTO
	#if you are running hpux machine, add -m to mail for it to not hang
fi

cat "$CLNTFLDR"/"$CLNT".rpt

#stop logging (if we were)
if [ "$RECORDPCAP" ]
then
	rm /tmp/$FIFO
	kill $PCAPPID
fi

#set stderr back to before if it was changed earlier
if [ ! "$DEBUG" ]
then
	exec 2>&3
fi

exit
