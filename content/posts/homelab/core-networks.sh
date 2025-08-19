#!/bin/sh

set -e

# ENV vars to be set by user
export CORE_API_LOGIN=${CORE_API_LOGIN}
export CORE_API_PASSWORD=${CORE_API_PASSWORD}

CORE_API_URL="${CORE_API_URL:=https://beta.api.core-networks.de}"

# ENV vars to be set by certbot
CERTBOT_DOMAIN=$2
CERTBOT_VALIDATION=$3

get_api_token() {
  echo -n "GET API token: ... "
  CORE_API_TOKEN=$(curl --silent --fail --request POST --data '{"login":"'${CORE_API_LOGIN}'","password":"'${CORE_API_PASSWORD}'"}' ${CORE_API_URL}/auth/token | jq -r '.token')
  #CORE_API_DNS_ZONES=$(curl --silent --fail -H "Authorization: Bearer ${CORE_API_TOKEN}" ${CORE_API_URL}/dnszones/ | jq -r '.[].name')
  CORE_API_DNS_ZONE=$(echo "${CERTBOT_DOMAIN}" | rev | cut -d"." -f2-3 | rev )
  echo -n "DELETE old _acme-challenge.* DNS record (if exists): ... "
  curl --silent --fail -H "Authorization: Bearer ${CORE_API_TOKEN}" --request POST --data '{"name":"'${CERTBOT_DOMAIN}'","type":"TXT"}' ${CORE_API_URL}/dnszones/${CORE_API_DNS_ZONE}/records/delete
  echo done
}

create_acme_challenge_record(){
  echo -n "CREATE new _acme-challenge.* DNS record: ... "
  curl --silent --fail -H "Authorization: Bearer ${CORE_API_TOKEN}" --request POST --data '{"name":"'${CERTBOT_DOMAIN}'","type":"TXT","data":"'${CERTBOT_VALIDATION}'"}' ${CORE_API_URL}/dnszones/${CORE_API_DNS_ZONE}/records/
  echo done
}

commit_api_dns_changes(){
  echo -n "COMMIT new _acme-challenge.* DNS record: ... "
  curl --silent --fail -H "Authorization: Bearer ${CORE_API_TOKEN}" --request POST ${CORE_API_URL}/dnszones/${CORE_API_DNS_ZONE}/records/commit
  echo done
}

apk add curl jq

if [ $1 = "present" ]; then
  get_api_token
  sleep 1s
  create_acme_challenge_record
  commit_api_dns_changes
  sleep 1s
else
  sleep 1s
  get_api_token
  commit_api_dns_changes
fi
