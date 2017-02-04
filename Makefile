REPO=quay.io/jcmoraisjr/beagle
TAG=0.1
build:
	CGO_ENAGLE=0 GOOS=linux go build -o rootfs/beagle
container: build
	docker build -t $(REPO):$(TAG) rootfs
push: container
	docker push $(REPO):$(TAG)
