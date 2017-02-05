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
	docker push $(REPO):$(TAG)
all: build container push
travis-build: build
ifeq ($(TRAVIS_PULL_REQUEST),false)
ifneq ($(TAG),)
	@docker login -u="$(DOCKER_USR)" -p="$(DOCKER_PWD)" $(DOCKER_HUB)
	@$(MAKE) container push
endif
endif
