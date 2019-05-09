#!/bin/bash

for i in `seq 1 100`; do 
	echo "Declining Pull request $i "
	curl -u repo_admin_user:repo_admin_password -X POST "http://localhost:7990/rest/api/1.0/projects/${projectKey}/repos/${repositorySlug}/pull-requests/$i/decline?version=1" -H "X-Atlassian-Token: no-check"
done

