SHELL := /bin/bash

# The name of the executable (default is current directory name)
TARGET := $(shell echo $${PWD\#\#*/})
.DEFAULT_GOAL := $(TARGET)

HAS_DEP := $(shell command -v dep;)
DEP_VERSION := v0.5.1

DIST := $(CURDIR)/dist
BIN := $(CURDIR)/bin
OUPUT_FILES := $(DIST) $(BIN)

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
	@ mkdir -p $(BIN)
	@ go build $(LDFLAGS) -o $(BIN)/$(TARGET) main.go

build: $(TARGET)
	@ true

clean:
	@ echo "==> Cleaning output files."
ifneq ($(OUPUT_FILES),)
	rm -rf $(OUPUT_FILES)
endif

test:
	@ echo "==> Testing $(TARGET)"
	@ go test -v ./...

install:
	@ echo "==> Installing $(TARGET)"
	@ go install $(LDFLAGS)

uninstall: clean
	@ echo "==> Uninstalling $(TARGET)"
	rm -f $$(which ${TARGET})

fmt:
	@ gofmt -l -w $(SRC)

simplify:
	@ gofmt -s -l -w $(SRC)

check:
	@ echo "==> Checking $(TARGET)"
	@ test -z $(shell gofmt -l main.go | tee /dev/stderr) || echo "[WARN] Fix formatting issues with 'make fmt'"
	@ for d in $$(go list ./... | grep -v /vendor/); do golint $${d}; done
	@ go vet ./...

run: install
	@ $(TARGET) ${ARGS}

dist:
	@ mkdir -p $(BIN)
	@ mkdir -p $(DIST)
	@ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BIN)/$(TARGET)
	tar -zcvf $(DIST)/$(TARGET)-linux-$(VERSION).tgz README.md LICENSE.txt -C $(BIN) $(TARGET)
	@ CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BIN)/$(TARGET)
	tar -zcvf $(DIST)/$(TARGET)-macos-$(VERSION).tgz README.md LICENSE.txt -C $(BIN) $(TARGET)
	@ CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BIN)/$(TARGET).exe
	tar -zcvf $(DIST)/$(TARGET)-windows-$(VERSION).tgz README.md LICENSE.txt -C $(BIN) $(TARGET).exe

benchmark:
	@ echo "==> Benchmarking $(TARGET)"
	@ go test -bench -v ./...

dependencies:
ifndef HAS_DEP
	@ echo "==> Installing dep"
	wget -q -O $(GOPATH)/bin/dep https://github.com/golang/dep/releases/download/$(DEP_VERSION)/dep-darwin-amd64
	chmod +x $(GOPATH)/bin/dep
endif
	@ echo "==> Downloading dependencies"
	@ dep ensure