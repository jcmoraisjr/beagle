### User vars:
# REPO_LOCAL: URL of the local repo, eg: localhost/project
# REPO_PUBLIC: URL of the public repository, eg: quay.io/username/project
# DOCKER_ROOT: optional, defaults to `rootfs`, root directory of Dockerfile
# DOCKER_HUB: URL of the hub, eg: quay.io, or empty if using Docker Hub

### Travis vars:
# TRAVIS*: default Travis-CI env vars
# DOCKER_USR: User used to login to Hub, using a Travis env var is not a bad idea. Tip: create a robot account
# DOCKER_PWD: Password of this user; USE Travis environment variable

GIT_COMMIT=git-$(shell git rev-parse --short HEAD)
GIT_TAG=false
ifeq ($(DOCKER_ROOT),)
DOCKER_ROOT=rootfs
endif

ifeq ($(TRAVIS),)
REPO?=$(REPO_LOCAL)
TAG?=latest
else
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
	docker build -t $(REPO):$(TAG) $(DOCKER_ROOT)
push:
	docker push $(REPO):$(TAG)
tag-push:
ifeq ($(GIT_TAG),true)
ifeq ($(TRAVIS_PULL_REQUEST),false)
	@docker login -u="$(DOCKER_USR)" -p="$(DOCKER_PWD)" $(DOCKER_HUB)
	@$(MAKE) container push
endif
endif
