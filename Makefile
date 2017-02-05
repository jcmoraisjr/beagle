GOOS=linux
GOARCH=amd64
ROOT_PKG=github.com/jcmoraisjr/beagle/pkg

.PHONY: build
build:
	CGO_ENAGLE=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build \
	  -ldflags "-s -w -X $(ROOT_PKG)/version.Product=Beagle -X $(ROOT_PKG)/version.Repository=$(GIT_REPO) -X $(ROOT_PKG)/version.Version=$(TAG)" \
	  -o rootfs/beagle \
	  $(ROOT_PKG)/beagle

REPO_LOCAL=localhost/beagle
REPO_PUBLIC=quay.io/jcmoraisjr/beagle
include container.mk
