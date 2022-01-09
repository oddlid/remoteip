FROM golang:latest as builder

COPY . ${GOPATH}/src/github.com/oddlid/remoteip/
WORKDIR ${GOPATH}/src/github.com/oddlid/remoteip
RUN make

FROM alpine:latest
LABEL maintainer="Odd E. Ebbesen <oddebb@gmail.com>"
RUN apk add --no-cache --update ca-certificates tzdata \
		&& rm -rf /var/cache/apk/*

RUN adduser -D -u 1000 srv
COPY --from=builder /go/src/github.com/oddlid/remoteip/remoteip.bin /usr/local/bin/remoteip
RUN chown srv /usr/local/bin/remoteip && chmod 555 /usr/local/bin/remoteip

USER srv

EXPOSE 1234
#ENTRYPOINT ["tini", "-g", "--", "remoteip"]
#CMD ["-h"]
