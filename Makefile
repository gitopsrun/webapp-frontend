
BUILD_DATE:=$(shell date +%s)
LOCAL_IMAGE:="test/frontend:$(BUILD_DATE)"

build:
	docker build -t $(LOCAL_IMAGE) .

# Build image and deploy it on Minikube using the local overlay
.PHONY: deploy
deploy: build
	mkdir -p deploy/overlays/dev && cp deploy/overlays/local/* deploy/overlays/dev
	cd deploy/overlays/dev && kustomize edit set image frontend=${LOCAL_IMAGE}
	kustomize build deploy/overlays/dev | kubectl apply -f-
	rm -rf deploy/overlays/dev
