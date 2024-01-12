#################################################################################################
###
### CURL the deployed containers healthcheck and return the status and SHA.
### check the SHA against a passed in parameter
###
### Input parameters ( not validated )
### 1 URL
### 2 APP SHA
###
### Returns
### 1 on failure
### 0 on sucess
###
#################################################################################################
URL=${1}
APP_SHA=${2}

#URL="get-into-teaching-app-dev"
#APP_SHA="de1bb0b"
#APP_SHA="de1bb0b"


if [ -z "${HTTPAUTH_USERNAME}" ]
then
        AUTHORITY=""
else
	AUTHORITY="--user ${HTTPAUTH_USERNAME}:${HTTPAUTH_PASSWORD}"
fi

rval=0
FULL_URL="https://${URL}.teacherservices.cloud/healthcheck.json"
http_status=$(curl ${AUTHORITY} -o /dev/null -s -w "%{http_code}"  ${FULL_URL})
if [ "${http_status}" != "200" ]
then
	echo "HTTP Status ${http_status}"
	rval=1
else
	echo "HTTP Status is Healthy"

        json=$(curl ${AUTHORITY}  -s -X GET ${FULL_URL})

        sha=$( echo ${json} | jq -r .app_sha)
        if [ "${sha}" != "${APP_SHA}"  ]
        then
		echo "APP SHA (${sha}) is not ${APP_SHA}"
        	rval=1
        else
                echo "APP SHA is correct"
        fi
fi
exit ${rval}
