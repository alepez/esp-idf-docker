MANTAINER=alepez
IMAGE_NAME=esp-idf
ESP_VERSION=5.1.2
BUILD=0
ESP_IDF_REF=482a8fb2d78e3b58eb21b26da8a5bedf90623213

VERSION=${ESP_VERSION}.${BUILD}
TAG=${MANTAINER}/${IMAGE_NAME}:${VERSION}

.PHONY: build
build:
	docker build -f Dockerfile -t ${TAG} --build-arg ESP_IDF_REF=${ESP_IDF_REF} .

.PHONY: publish
publish: build
	docker push ${TAG}
