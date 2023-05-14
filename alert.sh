#!/usr/bin/env bash
 
# Import credentials form config file
. /opt/ssh-login-alert-telegram/credentials.config
for i in "${USERID[@]}"
do
URL="https://api.telegram.org/bot${KEY}/sendMessage"
DATE="$(date "+%d %b %Y %H:%M")"
TZ="$(date "+%Z")"

if [ -n "$SSH_CLIENT" ]; then
	CLIENT_IP=$(echo $SSH_CLIENT | awk '{print $1}')

	SRV_HOSTNAME=$(hostname -f)
	SRV_IP=$(hostname -I | awk '{print $1}')

	IPINFO="https://ipinfo.io/${CLIENT_IP}"

	TEXT="<b>${SERVERNAME}</b>
	Connection from ${CLIENT_IP} as ${USER} to ${SRV_IP}
	Date: ${DATE}
	TimeZone:${TZ}
	More informations: ${IPINFO}"

        curl -s -d "chat_id=$i&text=${TEXT}&disable_web_page_preview=true&parse_mode=html" $URL > /dev/null
fi
done
