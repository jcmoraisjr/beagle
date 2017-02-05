ifeq ($(TRAVIS),)
REPO?=localhost/beagle
TAG?=latest
else
PR=$(TRAVIS_PULL_REQUEST)
DOCKER_HUB=quay.io
REPO=quay.io/jcmoraisjr/beagle
TAG=$(TRAVIS_TAG)
endif
.PHONY: build container push all tag-push
build:
	CGO_ENAGLE=0 GOOS=linux GOARCH=amd64 go build \
	  -ldflags "-s -w" \
	  -o rootfs/beagle
container:
	docker build -t $(REPO):$(TAG) rootfs
push:
	docker push $(REPO):$(TAG)
all: build container push
tag-push:
ifeq ($(PR),false)
ifneq ($(TAG),)
	@docker login -u="$(DOCKER_USR)" -p="$(DOCKER_PWD)" $(DOCKER_HUB)
	@$(MAKE) container push
endif
endif
