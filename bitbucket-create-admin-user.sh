#!/bin/bash

for i in `seq 1 100`; do 
	echo "Creating user user$i "
	curl -u sysadmin:sysadminpassword -X POST "http://localhost:7990/rest/api/1.0/admin/users?name=user$i&password=password$i&displayName=user$i&emailAddress=user$i@gmail.com" -H "X-Atlassian-Token: no-check"
done

for i in `seq 1 100`; do 
	echo "Updating user$i to sys admin"
	curl -u sysadmin:sysadminpassword -I -X PUT "http://localhost:7990/rest/api/1.0/admin/permissions/users?name=user$i&permission=SYS_ADMIN" -H "X-Atlassian-Token: no-check"
done
