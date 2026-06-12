BINARY_NAME := dreamcoder-dots
VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
LDFLAGS := -ldflags "-X github.com/dreamcoder08/dreamcoder-dots/installer/pkg/version.Version=$(VERSION)"

.PHONY: build build-all release clean

build:
	go build $(LDFLAGS) -o $(BINARY_NAME) .

build-all:
	@echo "Building for linux/amd64..."
	GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BINARY_NAME)-linux-amd64 .
	@echo "Building for linux/arm64..."
	GOOS=linux GOARCH=arm64 go build $(LDFLAGS) -o $(BINARY_NAME)-linux-arm64 .
	@echo "Building for darwin/amd64..."
	GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BINARY_NAME)-darwin-amd64 .
	@echo "Building for darwin/arm64..."
	GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BINARY_NAME)-darwin-arm64 .

release: build-all
	gh release create $(VERSION) $(BINARY_NAME)-* --title "v$(VERSION)" --generate-notes

clean:
	rm -f $(BINARY_NAME) $(BINARY_NAME)-*
