MANTAINER=alepez
IMAGE_NAME=esp-idf
ESP_VERSION=4.4.6
VERSION=${ESP_VERSION}.2
ESP_IDF_REF=357290093430e41e7e3338227a61ef5162f2deed
TAG=${MANTAINER}/${IMAGE_NAME}:${VERSION}

.PHONY: build
build:
	docker build -f Dockerfile -t ${TAG} --build-arg ESP_IDF_REF=${ESP_IDF_REF} .

.PHONY: publish
publish: build
	docker push ${TAG}
