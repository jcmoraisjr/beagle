.PHONY: default
default: build

REPO_LOCAL=localhost/beagle
REPO_PUBLIC=quay.io/jcmoraisjr/beagle
DOCKER_HUB=quay.io
include container.mk

GOOS=linux
GOARCH=amd64
ROOT_PKG=github.com/jcmoraisjr/beagle/pkg
GIT_REPO=$(shell git config --get remote.origin.url)
TIMESTAMP=$(shell date '+%Y/%m/%d_%H:%M:%S')

.PHONY: build
build:
	GOOS=$(GOOS) GOARCH=$(GOARCH) go build \
	  -ldflags "-s -w -X $(ROOT_PKG)/version.Product=Beagle -X $(ROOT_PKG)/version.Repository=$(GIT_REPO) -X $(ROOT_PKG)/version.Version=$(TAG) -X $(ROOT_PKG)/version.Timestamp=$(TIMESTAMP)" \
	  -o rootfs/beagle \
	  $(ROOT_PKG)/beagle
