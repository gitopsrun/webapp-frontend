VERSION:=latest
RELEASE_IMAGE:="gitopsrun/frontend:$(VERSION)"
BUILD_DATE:=$(shell date +%s)
LOCAL_IMAGE:="test/frontend:$(BUILD_DATE)"

.PHONY: release
release:
	git pull origin master
	git checkout master
	cd deploy/overlays/production && kustomize edit set image frontend=${RELEASE_IMAGE}
	git commit -a -m "Release $(VERSION)"
	git push origin master
	git tag $(VERSION)
	git push origin $(VERSION)

.PHONY: change
change:
	git pull origin master
	git checkout master
	echo $(BUILD_DATE) > src/TIMESTAMP
	git commit -a -m "Change src to $(BUILD_DATE)"
	git push origin master

build:
	docker build -t $(LOCAL_IMAGE) .

# Build image and deploy it on Minikube using the local overlay
.PHONY: deploy
deploy: build
	mkdir -p deploy/overlays/dev && cp deploy/overlays/local/* deploy/overlays/dev
	cd deploy/overlays/dev && kustomize edit set image frontend=${LOCAL_IMAGE}
	kustomize build deploy/overlays/dev | kubectl apply -f-
	rm -rf deploy/overlays/dev
