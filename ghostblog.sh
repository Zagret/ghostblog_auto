#!/bin/bash
webdir=/var/www
echo "This is a 7 step installation of GHOST"
FILE="/tmp/out.$$"
GREP="/bin/grep"
# MAKES SURE ONLY ROOT CAN RUN THE SCRIPT
if [[ $EUID -ne 0 ]]; then
   echo "This script must be RUS AS ROOT" 
   exit 1
fi
#Function to check the output of the command called prior
function check_output() { 
if [ $? -eq 0 ];then #Checks that the command returned 0 
echo -e "\tDONE" #Prints DONE if return was 0
else
echo -e "\tFAILED" #Prints FAILED if otherwise
fi
}

#1 ZIP & WGET
echo -n "1.Installing ZIP & WGET"
inst_zip=$(sudo apt-get install zip wget -y 2>&1)
check_output "$inst_zip"

#2 NODEJS
echo -n "2.Installing Nodejs"
inst_node=$(sudo apt-get install nodejs -y 2>&1)
check_output "$inst_node"

#3 NPM 2_5
echo -n "3.Installing NPM 2_5"
inst_npm=$(sudo npm install npm@2.5.0 -g -y 2>&1)
check_output "$inst_npm"

#4 CREATING THE DIRECTORIES 
if [[ -d "$webdir" && ! -L "$webdir" ]]
 then
echo -n "4.Directories"
echo -e "\t\t OK"
else
sudo mkdir /var/www
echo "4.Made directory $wedir"
fi

#5 !!REMOVES ANY POSSIBLE PRIOR GHOST FILES AND FOLDERS!! 
do_rmv=$(sudo rm -rf ghost 2>&1)
do_rmv2=$(sudo rm ghost-latest.zip 2>&1)

echo -n "5.Downloading GHOST"
get_ghost=$(sudo wget https://ghost.org/zip/ghost-latest.zip 2>&1)
check_output "$get_ghost"
#6 Unzippin GHOST
echo -n "6.Unzipping GHOST"
do_unzip=$(sudo unzip -d ghost ghost-latest.zip 2>&1)
check_output "$do_unzip"
#7 Installing the NPM production
cd /var/www/ghost
echo -n "7.NPM Production"
do_prod=$(sudo npm install --production 2>&1)
check_output "$do_prod"

sudo cp config.example.js config.js
echo "Please configure config.js and visit https://www.digitalocean.com/community/tutorials/how-to-create-a-blog-with-ghost-and-nginx-on-ubuntu-14-04"

