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
#
#
#Sent variable (host & port)
host=$1
port=$2
# #If empty IP then set 127.0.0.1 as default
if [ -z $host ]
then
host="127.0.0.1"
fi
if [ -z $port ];then
port=443
fi
#create the returned code
out="`echo x | timeout 5 openssl s_client -ssl3 -connect ${host}:${port} 2>/dev/null`"
ret=$?
#create a switch statement on $ret, exploit depend on result code
case "$ret" in
0)
	echo "VULNERABLE! SSLv3 detected.";
;;
124)
	echo "error: timeout connecting to host $host:$port";
;;
1)
	out=`echo $out | perl -pe 's|.*Cipher is (.*?) .*|$1|'`;
	if [ "$out" == "0000" ] || [ "$out" == "(NONE)" ];then
		echo "Not Vulnerable. We detected that this server does not support SSLv3";exit
	fi	
;;
*)
	echo "warning: $ret isn't a valid code while connecting to host $host:$port";
;;
esac
