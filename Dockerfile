ARG BUILDPLATFORM=amd64
FROM --platform=$BUILDPLATFORM alpine:latest as pre_build
RUN set -x \
    && apk update \
    && apk upgrade \
    && apk add --no-cache --virtual .builddeps git \
    && git clone https://github.com/wdhwang/minimalist-portfolio.git /usr/local/onepage \
    #&& git -c http.sslVerify=false clone https://msmp.my:8443/root/minimalist-portfolio.git /usr/local/onepage \
    && cd /usr/local/onepage && git clean -Xdf \
    && rm -f ./.githash && git log --pretty=format:"%h" -1 > ./.githash

FROM alpine:latest
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN set -x \
    && apk update \
    && apk add lighttpd
WORKDIR /var/www/localhost/htdocs
COPY --from=pre_build /usr/local/onepage/ ./

EXPOSE 80

ENTRYPOINT /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
