FROM openjdk:8u181-jre-alpine

RUN apk upgrade --update && \
    apk add --update --no-cache bash iputils openssh && \
    rm -rf /var/cache/apk/* && \
    addgroup corda && \
    adduser -G corda -D -s /bin/bash corda && \
    mkdir -p /opt/corda/cordapps && \
    mkdir -p /opt/corda/certificates && \
    mkdir -p /opt/corda/logs

ADD cordapps/*.jar /opt/corda/cordapps/
ADD network-bootstrapper/notary/corda.jar /opt/corda/corda.jar
ADD network-bootstrapper/notary/additional-node-infos/ /opt/corda/additional-node-infos/

EXPOSE 30000
EXPOSE 10001
EXPOSE 10002
EXPOSE 2222

COPY start-corda-node.sh /start-corda-node.sh
RUN chmod +x /start-corda-node.sh && \
    sync && \
    chown -R corda:corda /opt/corda

WORKDIR /opt/corda
ENV HOME=/opt/corda
USER corda

CMD ["/start-corda-node.sh"]
