PRJ=github.com/jcmoraisjr/beagle
GOOS=linux
GIT_REPO=$(shell git config --get remote.origin.url)
GIT_TAG=false

ifeq ($(TRAVIS),)
REPO?=localhost/beagle
TAG?=latest
else
DOCKER_HUB=quay.io
REPO=quay.io/jcmoraisjr/beagle
ifeq ($(TRAVIS_TAG),)
TAG=git-$(shell git rev-parse --short HEAD)
else
TAG=$(TRAVIS_TAG)
GIT_TAG=true
endif
endif

.PHONY: build container push tag-push

build:
	CGO_ENAGLE=0 GOOS=$(GOOS) GOARCH=amd64 go build \
	  -ldflags "-s -w -X $(PRJ)/version.Product=Beagle -X $(PRJ)/version.Repository=$(GIT_REPO) -X $(PRJ)/version.Version=$(TAG)" \
	  -o rootfs/beagle \
	  $(PRJ)/pkg
container:
	docker build -t $(REPO):$(TAG) rootfs
push:
	docker push $(REPO):$(TAG)
tag-push:
ifeq ($(GIT_TAG),true)
ifeq ($(TRAVIS_PULL_REQUEST),false)
	echo @docker login -u="$(DOCKER_USR)" -p="$(DOCKER_PWD)" $(DOCKER_HUB)
	@$(MAKE) container push
endif
endif
