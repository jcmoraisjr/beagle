REPO_PUBLIC=quay.io/jcmoraisjr/beagle
REPO_LOCAL=localhost/beagle
ROOT_PKG=github.com/jcmoraisjr/beagle/pkg
GOOS=linux
GOARCH=amd64
GIT_REPO=$(shell git config --get remote.origin.url)
GIT_COMMIT=git-$(shell git rev-parse --short HEAD)
GIT_TAG=false

ifeq ($(TRAVIS),)
REPO?=$(REPO_LOCAL)
TAG?=latest
else
DOCKER_HUB=quay.io
REPO=$(REPO_PUBLIC)
ifeq ($(TRAVIS_TAG),)
TAG=$(GIT_COMMIT)
else
TAG=$(TRAVIS_TAG)
GIT_TAG=true
endif
endif

.PHONY: build container push tag-push

build:
	CGO_ENAGLE=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build \
	  -ldflags "-s -w -X $(ROOT_PKG)/version.Product=Beagle -X $(ROOT_PKG)/version.Repository=$(GIT_REPO) -X $(ROOT_PKG)/version.Version=$(TAG)" \
	  -o rootfs/beagle \
	  $(ROOT_PKG)/beagle
container:
	docker build -t $(REPO):$(TAG) rootfs
push:
	docker push $(REPO):$(TAG)
tag-push:
ifeq ($(GIT_TAG),true)
ifeq ($(TRAVIS_PULL_REQUEST),false)
	@docker login -u="$(DOCKER_USR)" -p="$(DOCKER_PWD)" $(DOCKER_HUB)
	@$(MAKE) container push
endif
endif
