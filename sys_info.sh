#!/bin/bash

if [ $UID -eq 0 ]
then
    echo "Please do not run this script as root"
    exit
fi

#Variables
output=$HOME/sys_info.txt
ip=$(ip addr | grep inet | tail -3 | head -1 | awk {'print $2'})
execs=$(find /home -type f -perm 777 2>/dev/null)
files=('/etc/passwd' '/etc/shadow')

##Make Research Folder
if [ ! -d $HOME/research ]
then
    mkdir $HOME/research
else
    echo "Home/research already exists"
fi

#Ouptut File Check
if [ -f $output ]
then
    echo "Output File Exists... Overwriting." && > $output
fi

##Title Sequence
echo -e "#################### A Quick System Audit ####################\n\n" >> $output
date >> $output
echo "" $output

##Machine Type Info
echo "Machine Type Info:" >> $output
echo $MACHTYPE >> $output

##Uname Info
echo -e "Uname info: \n$(uname -a)\n" >> $output

##Some Title Here About IP Stuff
echo -e "IP Info: $(ip addr | head -9 | tail -1) \n" >> $output
echo "Hostname: $(hostname -s)" >> $output
echo "DNS Servers:" >> $output
cat /etc/resolv.conf >> $output

##Hardware Info
echo "Memory Info:" >> $output
free >> $output
echo -e "\nCPU Info:" >> $output
lscpu | grep CPU >> $output
echo -e "\nDisk Usage:" >> $output
df -H | head -2 >> $output
echo -e "\nWho is logged in: \n $(who -a) \n" >> $output

#end

#Next Excercise
echo -e "\n777 Files:" >> $output
$execs >> $output
echo -e "\nTop 10 Processes" >> $output
ps aux --sort %mem | head -11 | awk {'print $1, $2, $3, $3, $11'} >> $output


#Useful Loops Activity
echo -e "\n/etc/ shadow and passwd Permissions" >> $output
for file in ${files[@]}
do
	ls -l $file >> $output
done

#Check Sudo on each user in homedir
#u=users in homedir
echo -e "\nCheck Sudo perm each user in homedir\n"
echo -e "\nScript in development\n"

#for u in $(ls /home)
#do
#	sudo -lu $u >> $output
#done
