FROM alpine:3
RUN  apk add  bash  bc curl
COPY . .
RUN chmod +x /*.sh
COPY crontab /etc/crontabs/root
CMD crond -f 