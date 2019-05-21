#!/bin/bash

function printUsage {
	echo ""
	echo "$0"
	echo "--projectKey				: Project Key"
	echo "--repository				: Full Repository name"
	echo "--userSlug				: User Slug or short user id"
	echo "--password				: Self explanatory"
	echo "--bitbucketServerUrl			: Bitbucket Server Url "
	echo "--fromValue				: First Id of List of PRs to be declined"
	echo "--toValue				: Final Id of Pr to be declined"
	echo ""
	echo "Sample usage:"
	echo "$0 --projectKey=<project-key> --repository=<repository> --userSlug=<user-slug> --password=<pwd> --bitbucketServerUrl=<bitbucket-server-url> --fromValue=<first-pr-id> --toValue=<last-pr-id>"
}

# The below function to extract version of Pull Request from json response has been copied from https://gist.github.com/cjus/1047794. , courtesy of Carlos Justiniano
function getPrVersionFromJsonResponse {
    temp=`echo $1 | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w version | cut -d":" -f2| sed -e 's/^ *//g' -e 's/ *$//g' `
	version=${temp##*|}
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            printUsage
            exit
            ;;
        --projectKey)
            projectKey=$VALUE
            ;;
        --repository)
            repository=$VALUE
            ;;
		--userSlug)
            userSlug=$VALUE
            ;;
		--password)
            password=$VALUE
            ;;			
		--bitbucketServerUrl)
            bitbucketServerUrl=$VALUE
            ;;
		--fromValue)
            fromValue=$VALUE
            ;;		
		--toValue)
            toValue=$VALUE
            ;;			
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            printUsage
            exit 1
            ;;
    esac
    shift
done

if [ -z "$projectKey" ] || [ -z "$repository" ] || [ -z "$userSlug" ] || [ -z "$password" ] || [ -z "$bitbucketServerUrl" ] || [ -z "$fromValue" ] || [ -z "$toValue" ] ; then
	echo ""
	echo "Looks like one of the following inputs {projectKey, repository, userSlug, password, bitbucketServerUrl, fromValue, toValue} have not been supplied"
	echo ""
	echo "See usage as mentioned below : "
	printUsage
	exit 1
fi

trap "exit" INT
for i in `seq $fromValue $toValue`; do 
	echo "Getting Version of Pull Request ID $i"
	jsonResponse=$(curl -u "$userSlug:$password" -X GET "$bitbucketServerUrl/rest/api/1.0/projects/$projectKey/repos/$repository/pull-requests/$i")
	getPrVersionFromJsonResponse $jsonResponse
	
	echo "Declining Pull request $i whose version is $version"
	curl -u "$userSlug:$password" -X POST "$bitbucketServerUrl/rest/api/1.0/projects/$projectKey/repos/$repository/pull-requests/$i/decline?version=$version" -H "X-Atlassian-Token: no-check"
done