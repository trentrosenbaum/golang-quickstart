# Go commands
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get

DIST := $(CURDIR)/dist
BIN := $(CURDIR)/bin

HAS_DEP := $(shell command -v dep;)
DEP_VERSION := v0.5.1

BINARY_NAME=quickstart
VERSION=v0.0.1-SNAPSHOT
LDFLAGS := "-X main.version=${VERSION}"

OUPUT_FILES := $(BIN) $(DIST)

# Recipe
all: test build

.PHONY: test
test:
	$(GOTEST) -v ./...

.PHONY: build
build:
	$(GOBUILD) -o $(BIN)/$(BINARY_NAME) -ldflags $(LDFLAGS) -v

.PHONY: run
run:
	@ $(GOBUILD) -o $(BIN)/$(BINARY_NAME) -ldflags $(LDFLAGS) -v ./...
	@ $(BIN)/$(BINARY_NAME)

.PHONY: clean
clean:
ifneq ($(OUPUT_FILES),)
	rm -rf $(OUPUT_FILES)
endif

.PHONY: dist
dist:
	mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(BIN)/$(BINARY_NAME) -ldflags $(LDFLAGS)
	tar -zcvf $(DIST)/$(BINARY_NAME)-linux-$(VERSION).tgz README.md LICENSE.txt -C $(BIN) $(BINARY_NAME)
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o $(BIN)/$(BINARY_NAME) -ldflags $(LDFLAGS)
	tar -zcvf $(DIST)/$(BINARY_NAME)-macos-$(VERSION).tgz README.md LICENSE.txt -C $(BIN) $(BINARY_NAME)
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $(BIN)/$(BINARY_NAME).exe -ldflags $(LDFLAGS)
	tar -zcvf $(DIST)/$(BINARY_NAME)-windows-$(VERSION).tgz README.md LICENSE.txt -C $(BIN) $(BINARY_NAME)

.PHONY: benchmark
benchmark:
	$(GOTEST) -bench -v ./...

.PHONY: dependencies
dependencies:
ifndef HAS_DEP
	wget -q -O $(GOPATH)/bin/dep https://github.com/golang/dep/releases/download/$(DEP_VERSION)/dep-darwin-amd64
	chmod +x $(GOPATH)/bin/dep
endif
	dep ensure