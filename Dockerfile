FROM alpine

COPY root /

RUN adduser -S -D -H -h /xmrig xmrig && \
    apk update && \
    apk upgrade && \
    apk add --no-cache libuv libmicrohttpd util-linux

USER xmrig

WORKDIR /xmrig

ENTRYPOINT [ "./xmrig" ]
CMD [ "--help" ]
