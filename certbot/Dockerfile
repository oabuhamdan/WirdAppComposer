From certbot/certbot:latest
COPY scripts/ /var/lib/letsenc/
RUN chmod 777 /var/lib/letsenc/authenticator.sh
RUN chmod 777 /var/lib/letsenc/cleanup.sh
RUN apk add --no-cache curl
#RUN certbot certonly --email osamaabuhamdan@yahoo.com  --staging --non-interactive --agree-tos --manual --preferred-challenges=dns --manual-auth-hook /var/lib/letsencrypt/authenticator.sh --manual-cleanup-hook /var/lib/letsencrypt/cleanup.sh --manual-ip-logging-ok -d *.wird.app
#COPY /etc/letsencrypt
