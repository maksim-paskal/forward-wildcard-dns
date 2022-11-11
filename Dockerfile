FROM coredns/coredns:1.9.3

ENV SERVER_IP=127.0.0.1
ENV WILDCARD=".*\.dev\.com"

COPY ./Corefile /etc/coredns/Corefile

CMD ["-conf", "/etc/coredns/Corefile"]
