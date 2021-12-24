FROM alpine:3.13
RUN apk add --no-cache \
    bash=5.1.8-r0 \
    ip6tables=1.8.7-r1 \
    iptables=1.8.7-r1 \
    wireguard-tools=1.0.20210424-r0
ENV LOCAL_NETWORK= \
    KEEPALIVE=0 \
    VPNDNS= \
    PORT_FORWARDING=0 \
    EXIT_ON_FATAL=0 \
    FIREWALL=1 \
    WG_USERSPACE=0 \
    PEER_PORT=51820
RUN sed -i 's/cmd sysctl.*/set +e \&\& sysctl -q net.ipv4.conf.all.src_valid_mark=1 \&\& set -e/' /usr/bin/wg-quick
RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing wireguard-go=0.0.20210212-r0
WORKDIR /app
COPY run /app
RUN chmod 755 /app/run
VOLUME /config
CMD ["/app/run"]