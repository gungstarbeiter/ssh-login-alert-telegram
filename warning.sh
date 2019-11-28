#!/bin/bash

# Import credentials form config file
. /opt/ssh-login-alert-telegram/credentials.config
for i in "${USERID[@]}"
do

URL="https://api.telegram.org/bot${KEY}/sendMessage"
DATE="$(date "+%d %b %Y")"
TZ="$(date "+%Z")"

CHECK=$(awk -v d1="$(date --date="-1 min" "+%b %_d %H:%M")" -v d2="$(date "+%b %_d %H:%M")" '$0 > d1 && $0 < d2 || $0 ~ d2' /var/l$
if [[ $CHECK == *"closed"* ]]; then
  ATTEMPT_USER=$(echo $CHECK | awk '{print $11}')
  ATTEMPT_IP=$(echo $CHECK | awk '{print $12}')
  ATTEMPT_TIME=$(echo $CHECK | awk '{print $3}')

  SRV_IP=$(hostname -I | awk '{print $1}')
  IPINFO="https://ipinfo.io/${ATTEMPT_IP}"

  TEXT="<b>!WARNING!</b>
  <b>${SERVERNAME}</b>
  Connection attempt failed from ${ATTEMPT_IP} as ${ATTEMPT_USER} to ${SRV_IP}
  Date: ${DATE} ${ATTEMPT_TIME}
  TimeZone: ${TZ}
  More informations: ${IPINFO}
  <b>!WARNING!</b>"

  echo "$TEXT"
  curl -x http://${PROXY_USER}:${PROXY_PASS}@${PROXY_IP}:${PROXY_PORT} -s -d "chat_id=$i&text=${TEXT}&disable_web_page_preview=true&parse_mode=html" $URL > /dev/null
fi
done
