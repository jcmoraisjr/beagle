# REPO_LOCAL: URL of the local repo, eg: localhost/project
# REPO_PUBLIC: URL of the public repository, eg: quay.io/username/project
# TRAVIS*: default Travis-CI env vars

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

.PHONY: container push tag-push
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
