#!/bin/bash

echo "ADMINforJUSTICE1220!" | sudo -S groupadd docker
exit_code=$?

if [ ${exit_code} -eq '9' ]
then
	echo "already exists"
else
	echo "doesn't exist"
fi

echo "got here"





