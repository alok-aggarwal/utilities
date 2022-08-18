FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install wget -y

COPY exec /exec
COPY execed /execed
COPY execed2 /execed2
COPY start.sh start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
