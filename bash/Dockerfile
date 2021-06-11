FROM alpine:latest

RUN  apk add  bash  bc curl
COPY yvbeach-etl.sh /yvbeach-etl.sh
RUN chmod +x /yvbeach-etl.sh
RUN echo '*  *  *  *  *   /yvbeach-etl.sh' > /etc/crontabs/root
CMD crond -l 8 -f
