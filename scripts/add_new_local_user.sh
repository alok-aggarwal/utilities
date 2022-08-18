#!/bin/bash

#test I am root
if [[ ${UID} -ne 0 ]]
then
 echo "You are not root, can't add users"
 exit 1
fi

if [[ $# < 1 ]]
then
 echo "Usage: $0 <username> [comment]"
 exit 1
fi



#Ask for username, name and pwd
USER_NAME=$1
COMMENT=$2
#generate 32 byte pwd
#PASSWORD=$(date +%s%N | sha256sum | head -c32)
PASSWORD=$1

#create the user
useradd -c "${COMMENT}" -m ${USER_NAME}
if [[ ${?} -ne 0 ]]
then
 echo "Could not add user {USER_NAME}"
 exit 1
fi
#add password to this account
#--stdin means take from stdin. In our case its the preceding pipe. then set it agains the user
#echo ${PASSWORD} | passwd --stdin ${USER_NAME}
#passwd ${PASSWORD} ${USER_NAME}
#if [[ ${?} -ne 0 ]]
#then
# echo "Could not add user pssword {USER_NAME}"
# exit 1
#fi
# Force password change on first login.
#passwd -e ${USER_NAME}

#Display information
echo "Account details:"
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"

