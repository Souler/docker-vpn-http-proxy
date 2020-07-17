FROM alpine:3.12.0

RUN apk --no-cache add openvpn caddy

WORKDIR /app

RUN mkdir caddy/
RUN mkdir openvpn/
COPY . .

EXPOSE 80

CMD ["/app/bin/start.sh"]
