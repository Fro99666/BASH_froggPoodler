#!/bin/bash
#  Copyright (C) 2014 by Dan Varga
#  dvarga@redhat.com
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
# ###
#
#            _ __ _     
#        ((-)).--.((-))
#        /     ''     \  
#       (   \______/   )           
#        \    (  )    / 
#        / /~~~~~~~~\ \
#   /~~\/ /          \ \/~~\
#  (   ( (            ) )   )
#   \ \ \ \          / / / /
#   _\ \/  \.______./  \/ /_
#   ___/ /\__________/\ \___
# ########################### #
# mod by Frogg	on 2014/10/17 #
# => admin@frogg.fr			  #
# => Vulnerability POODLE	  #
# => CVE-2014-3566			  #
# ########################### #
# * Security alert 
# => http://linuxfr.org/news/cve-2014-3566-vulnerabilite-poodle
#
# * Script call = bash poodle.sh {serverIP} {serverPort}
# => info : serverIP and serverPort are optional
#
# * 20141017 - Frogg update:
# => if script ip isnt set, set 127.0.0.1 as default ip
# => change if and else if for a switch
# => added some comments
# => added text color and formating
#
#
#Sent variable (host & port)
host=$1
port=$2
# #If empty IP then set 127.0.0.1 as default
if [ -z $host ];then
host="127.0.0.1"
fi
if [ -z $port ];then
port=443
fi
#create the returned code
out="`echo x | timeout 5 openssl s_client -ssl3 -connect ${host}:${port} 2>/dev/null`"
ret=$?

echo -e "\n\e[1m\e[4mCVE-2014-3566 - Poodle vulnerability result :\e[0m"

#create a switch statement on $ret, exploit depend on result code
case "$ret" in
0)
	echo -e "\e[1m\e[97m\e[41mVULNERABLE! SSLv3 detected.\e[0m\n";
;;
124)
	echo -e "\e[33merror: timeout connecting to host $host:$port\e[0m\n";
;;
1)
	out=`echo $out | perl -pe 's|.*Cipher is (.*?) .*|$1|'`;
	if [ "$out" == "0000" ] || [ "$out" == "(NONE)" ];then
		echo -e "\e[32mNot Vulnerable. We detected that this server does not support SSLv3\e[0m\n";exit
	fi	
;;
*)
	echo -e "\e[33mwarning: $ret isn't a valid code while connecting to host $host:$port\e[0m\n";
;;
esac
