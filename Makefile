SHELL := /bin/bash

# The name of the executable (default is current directory name)
TARGET := $(shell echo $${PWD\#\#*/})
.DEFAULT_GOAL := $(TARGET)

HAS_DEP := $(shell command -v dep;)
DEP_VERSION := v0.5.1

DIST := $(CURDIR)/dist
OUPUT_FILES := $(DIST) $(TARGET)

# These will be provided to the target
VERSION := "v1.0.0-SNAPSHOT"
BUILD := `git rev-parse HEAD`

# Use linker flags to provide version/build settings to the target
LDFLAGS := -ldflags "-X=main.Version=$(VERSION) -X=main.Build=$(BUILD)"

# go source files, ignore vendor directory
SRC := $(shell find . -type f -name '*.go' -not -path "./vendor/*")

.PHONY: all build clean test install uninstall fmt simplify check run dist benchmark dependencies

all: dependencies check test install

$(TARGET): $(SRC)
	@ go build $(LDFLAGS) -o $(TARGET)

build: $(TARGET)
	@ true

clean:
ifneq ($(OUPUT_FILES),)
	rm -rf $(OUPUT_FILES)
endif

test:
	@ go test -v ./...

install:
	@ go install $(LDFLAGS)

uninstall: clean
	rm -f $$(which ${TARGET})

fmt:
	@ gofmt -l -w $(SRC)

simplify:
	@ gofmt -s -l -w $(SRC)

check:
	@ test -z $(shell gofmt -l main.go | tee /dev/stderr) || echo "[WARN] Fix formatting issues with 'make fmt'"
	@ for d in $$(go list ./... | grep -v /vendor/); do golint $${d}; done
	@ go vet ${SRC}

run: install
	@ $(TARGET) ${ARGS}

dist:
	@ mkdir -p $(DIST)
	@ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(DIST)/$(TARGET) $(LDFLAGS)
	tar -zcvf $(DIST)/$(TARGET)-linux-$(VERSION).tgz README.md LICENSE.txt -C $(DIST) $(TARGET)
	@ CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o $(DIST)/$(TARGET) $(LDFLAGS)
	tar -zcvf $(DIST)/$(TARGET)-macos-$(VERSION).tgz README.md LICENSE.txt -C $(DIST) $(TARGET)
	@ CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $(DIST)/$(TARGET).exe $(LDFLAGS)
	tar -zcvf $(DIST)/$(TARGET)-windows-$(VERSION).tgz README.md LICENSE.txt -C $(DIST) $(TARGET).exe

benchmark:
	@ go test -bench -v ./...

dependencies:
ifndef HAS_DEP
	wget -q -O $(GOPATH)/bin/dep https://github.com/golang/dep/releases/download/$(DEP_VERSION)/dep-darwin-amd64
	chmod +x $(GOPATH)/bin/dep
endif
	@ dep ensure