ifeq ($(TRAVIS),)
REPO=localhost/beagle
TAG=latest
else
REPO=quay.io/jcmoraisjr/beagle
TAG=$(TRAVIS_TAG)
endif
.PHONY: build container push all travis-build
build:
	CGO_ENAGLE=0 GOOS=linux GOARCH=amd64 go build \
	  -ldflags "-s -w" \
	  -o rootfs/beagle
container:
	docker build -t $(REPO):$(TAG) rootfs
push:
	echo docker push $(REPO):$(TAG)
all: build container push
travis-build: build
ifeq ($(TRAVIS_PULL),false)
ifneq ($(TAG),)
	@$(MAKE) container push
endif
endif
