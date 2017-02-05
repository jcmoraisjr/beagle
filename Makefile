REPO=quay.io/jcmoraisjr/beagle
TAG=$(TRAVIS_TAG)
test:
	@echo $(TAG)
build:
	CGO_ENAGLE=0 GOOS=linux go build -o rootfs/beagle
container: build
	docker build -t $(REPO):$(TAG) rootfs
push: container
	docker push $(REPO):$(TAG)
