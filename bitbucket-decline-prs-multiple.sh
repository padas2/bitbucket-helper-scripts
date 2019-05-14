#!/bin/bash

function printHelp {
	echo "-projectKey				: Project Key"
	echo "-repository				: Full Repository name"
	echo "-userSlug				: User Slug or short user id"
	echo "-password				: Self explanatory"
	echo "-bitbucketServerUrl			: Bitbucket Server Url "
	echo "-fromValue				: First Id of List of PRs to be declined"
	echo "-toValue				: Final Id of Pr to be declined"
}

if [ $# -eq 0 ]
  then
	echo ""
	echo "Since no arguments have been passed, printing help"
	echo "" 
	echo ""
    printHelp
	exit 1
fi

trap "exit" INT
for i in `seq 1080 1200`; do 
	echo "Declining Pull request $i "
	curl -u "plugintester:Plugintester123" -X POST "https://git.dev.pega.io/rest/api/1.0/projects/LOADTEST/repos/prpc-platform/pull-requests/$i/decline?version=0" -H "X-Atlassian-Token: no-check"
done

