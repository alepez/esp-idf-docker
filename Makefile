MANTAINER=alepez
IMAGE_NAME=esp-idf
ESP_VERSION=4.4.6
VERSION=${ESP_VERSION}.0
ESP_IDF_REF=11eaf41b37267ad7709c0899c284e3683d2f0b5e
TAG=${MANTAINER}/${IMAGE_NAME}:${VERSION}

.PHONY: build
build:
	docker build -f Dockerfile -t ${TAG} --build-arg ESP_IDF_REF=${ESP_IDF_REF} .

.PHONY: publish
publish: build
	docker push ${TAG}
