FROM golang:stretch as builder

RUN go get -d -u github.com/oddlid/remoteip
WORKDIR ${GOPATH}/src/github.com/oddlid/remoteip
RUN go get -d -v ./...
RUN make

FROM alpine:latest
LABEL maintainer="Odd E. Ebbesen <oddebb@gmail.com>"
RUN apk add --no-cache --update tini ca-certificates \
		&& \
		rm -rf /var/cache/apk/*

RUN adduser -D -u 1000 srv
COPY --from=builder /go/src/github.com/oddlid/remoteip/remoteip.bin /usr/local/bin/remoteip
RUN chown srv /usr/local/bin/remoteip && chmod 555 /usr/local/bin/remoteip

USER srv

EXPOSE 1234
ENTRYPOINT ["tini", "-g", "--", "remoteip"]
#CMD ["-h"]
