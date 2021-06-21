FROM alpine:3
RUN  apk add  bash  bc curl
COPY yvbeach-etl.sh /yvbeach-etl.sh
COPY yvbeach-etl-windy-com.sh /yvbeach-etl-windy-com.sh
RUN chmod +x /yvbeach-etl.sh
RUN echo '*  *  *  *  *   /yvbeach-etl.sh' > /etc/crontabs/root
RUN echo '*/5  *  *  *  *   /yvbeach-etl-windy-com.sh' >> /etc/crontabs/root
CMD crond -f 