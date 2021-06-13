# Beagle

* v0.x: Reusable Makefile for Travis CI and Docker builds.
* v1.x: GitHub Actions and Docker build experiments.

# Usage

 `include container.mk` inside Makefile after providing some variables:

    REPO_LOCAL=localhost/awesome-project
    REPO_PUBLIC=quay.io/my-user/awesome-project
    DOCKER_HUB=quay.io
    DOCKER_ROOTFS=rootfs
    include container.mk

Where:

* `REPO_LOCAL`: URL used by Docker to create local images
* `REPO_PUBLIC`: URL used by Docker to push images when running on Travis CI
* `DOCKER_HUB`: Where to login before push a new image
* `DOCKER_ROOTFS`: Optional, root directory of Dockerfile, defaults to `rootfs`

Provide as Travis CI environment variables:

* `DOCKER_USR`: Username - tip: use a robot account
* `DOCKER_PWD`: Password of this user

After `include container.mk` Makefile will have these new variables:

* `GIT_COMMIT`: Short git commit of this build: `git-xxxxxxx`
* `REPO` and `TAG`: REPO url and TAG name used to build and push image

`container.mk` add the following targets to Makefile:

* `image`: Build a new Docker image
* `push`: Push a Docker image to a image repository
* `tag-push`: Push only if Travis CI tells that this build has a tag and is not a pull request

# Default target

Typing just `make` will run the first declared target, which is the default target of the Makefile.

The following fragment declares `my-build` as the default target, declaring it as a dependency of the *real* default. This way `my-build` will behave like a default target and will have access to variables declared in `container.mk`.

    .PHONY: default
    default: my-build

    REPO_LOCAL=localhost/beagle
    REPO_PUBLIC=quay.io/jcmoraisjr/beagle
    DOCKER_HUB=quay.io
    include container.mk

    .PHONY: my-build
    my-build:
        ...

There is also [.DEFAULT_GOAL](https://www.gnu.org/software/make/manual/html_node/How-Make-Works.html) but it isn't provided on make <= 3.80.
