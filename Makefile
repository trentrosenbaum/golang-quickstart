# Go commands
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get

HAS_DEP := $(shell command -v dep;)
DEP_VERSION := v0.5.1

BINARY_NAME=quickstart
VERSION=v0.0.1-SNAPSHOT
LDFLAGS := "-X main.version=${VERSION}"
DIST := $(CURDIR)/_dist

OUPUT_FILES := $(BINARY_NAME) $(BINARY_NAME).exe $(DIST)

# Tasks
all: test build

.PHONY: test
test:
	$(GOTEST) -v ./...

.PHONY: build
build:
	$(GOBUILD) -o $(BINARY_NAME) -ldflags $(LDFLAGS) -v

.PHONY: run
run:
	@ $(GOBUILD) -o $(BINARY_NAME) -ldflags $(LDFLAGS) -v ./...
	@ ./$(BINARY_NAME)

.PHONY: clean
clean:
ifneq ($(OUPUT_FILES),)
	rm -rf $(OUPUT_FILES)
endif

.PHONY: dist
dist:
	mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(BINARY_NAME) -ldflags $(LDFLAGS)
	tar -zcvf $(DIST)/$(BINARY_NAME)-linux-$(VERSION).tgz $(BINARY_NAME) README.md LICENSE.txt
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o $(BINARY_NAME) -ldflags $(LDFLAGS)
	tar -zcvf $(DIST)/$(BINARY_NAME)-macos-$(VERSION).tgz $(BINARY_NAME) README.md LICENSE.txt
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $(BINARY_NAME).exe -ldflags $(LDFLAGS)
	tar -zcvf $(DIST)/$(BINARY_NAME)-windows-$(VERSION).tgz $(BINARY_NAME) README.md LICENSE.txt

.PHONY: bootstrap
bootstrap:
ifndef HAS_DEP
	wget -q -O $(GOPATH)/bin/dep https://github.com/golang/dep/releases/download/$(DEP_VERSION)/dep-darwin-amd64
	chmod +x $(GOPATH)/bin/dep
endif
	dep ensure