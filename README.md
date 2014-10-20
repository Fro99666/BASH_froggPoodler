froggPoodler
============

this code is used to test Poodle vulnerability on SSL3 exploit,
based on Dan Varga works (from redhat) script.
I made some change and now the Poodle vulnerability check is more clean for me...

Script call :

bash poodle.sh {serverIP} {serverPort}
info : serverIP and serverPort are optional

* 20141017 - Frogg change from original:
 => if script ip isnt set, set 127.0.0.1 as default ip
 => change if and elseif for a switch
 => added some comments
