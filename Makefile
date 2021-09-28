MANTAINER=alepez
IMAGE_NAME=esp-idf
VERSION=4.3.1                                                   # KEEP_UPDATED
ESP_IDF_REF=2e74914051d14ec2290fc751a8486fb51d73a31e            # KEEP_UPDATED
TAG=${MANTAINER}/${IMAGE_NAME}:${VERSION}

.PHONY: build
build:
	docker build -f Dockerfile -t ${TAG} --build-arg ESP_IDF_REF=${ESP_IDF_REF} .

.PHONY: publish
publish: build
	docker push ${TAG}
