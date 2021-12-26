FROM golang:1.15.15-alpine3.13 AS builder

RUN apk --no-cache add git

COPY / /src

ARG GIT_TAG

RUN cd /src && \
    ROOT_PKG=github.com/jcmoraisjr/beagle/pkg && \
    GIT_REPO=$(git config --get remote.origin.url) && \
    GIT_VERSION=${GIT_TAG:-git-$(git rev-parse --short HEAD)} && \
    TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ') && \
    CGO_ENABLED=0 go build \
        -ldflags "-s -w -X ${ROOT_PKG}/version.Product=Beagle -X ${ROOT_PKG}/version.Repository=${GIT_REPO} -X ${ROOT_PKG}/version.Version=${GIT_VERSION} -X ${ROOT_PKG}/version.Timestamp=${TIMESTAMP}" \
        -o beagle ${ROOT_PKG}/beagle

FROM alpine:3.13

COPY --from=builder /src/beagle .

CMD ["./beagle"]
