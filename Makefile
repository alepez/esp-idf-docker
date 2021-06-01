MANTAINER=alepez
IMAGE_NAME=esp-idf
VERSION=4.3-beta3
TAG=${MANTAINER}/${IMAGE_NAME}:${VERSION}

.PHONY: build
build:
	docker build -f Dockerfile . -t ${TAG}

.PHONY: publish
publish: build
	docker push ${TAG}
