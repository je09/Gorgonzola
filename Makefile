VERSION := $(shell git describe --tags --always)
OS := $(shell uname -s)

clean:
	echo "Cleaning up"
	rm -rf bin

mac-darwin64: BIN_DIR := bin/darwin-64
mac-darwin64:
	# Create macOS .app dir
	mkdir -p $(BIN_DIR)/Gorgonzola.app/Contents/MacOS $(BIN_DIR)/Gorgonzola.app/Contents/Resources
	# Copy app icon
	cp macMisc/AppIcon.icns $(BIN_DIR)/Gorgonzola.app/Contents/Resources
	# Copy Info.plist
	cp macMisc/Info.plist $(BIN_DIR)/Gorgonzola.app/Contents
	# Set version
	/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '${VERSION}'" $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${VERSION}'" $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist

	# Build project
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 go build -o ./$(BIN_DIR)/Gorgonzola.app/Contents/MacOS/gorgonzola cmd/main.go

mac-darwinarm64: BIN_DIR := bin/darwin-arm64
mac-darwinarm64:
	# Create macOS .app dir
	mkdir -p $(BIN_DIR)/Gorgonzola.app/Contents/MacOS $(BIN_DIR)/Gorgonzola.app/Contents/Resources
	# Copy app icon
	cp macMisc/AppIcon.icns $(BIN_DIR)/Gorgonzola.app/Contents/Resources
	# Copy Info.plist
	cp macMisc/Info.plist $(BIN_DIR)/Gorgonzola.app/Contents
	# Set version
	/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '${VERSION}'" $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${VERSION}'" $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist

	# Build project
	GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 go build -o ./$(BIN_DIR)/Gorgonzola.app/Contents/MacOS/gorgonzola cmd/main.go

mac-darwin64: BIN_DIR := bin/darwin-64
linux-darwin64:
	# Create macOS .app dir
	mkdir -p $(BIN_DIR)/Gorgonzola.app/Contents/MacOS $(BIN_DIR)/Gorgonzola.app/Contents/Resources
	# Copy app icon
	cp macMisc/AppIcon.icns $(BIN_DIR)/Gorgonzola.app/Contents/Resources
	# Copy Info.plist
	cp macMisc/Info.plist $(BIN_DIR)/Gorgonzola.app/Contents
	# Set version
	plistutil -i $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist -o $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist -s CFBundleShortVersionString ${VERSION}
	plistutil -i $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist -o $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist -s CFBundleVersion ${VERSION}

	# Build project
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 go build -o ./$(BIN_DIR)/Gorgonzola.app/Contents/MacOS/gorgonzola cmd/main.go

linux-darwinarm64: BIN_DIR := bin/darwin-arm64
linux-darwinarm64:
	# Create macOS .app dir
	mkdir -p $(BIN_DIR)/Gorgonzola.app/Contents/MacOS $(BIN_DIR)/Gorgonzola.app/Contents/Resources
	# Copy app icon
	cp macMisc/AppIcon.icns $(BIN_DIR)/Gorgonzola.app/Contents/Resources
	# Copy Info.plist
	cp macMisc/Info.plist $(BIN_DIR)/Gorgonzola.app/Contents
	# Set version
	plistutil -i $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist -o $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist -s CFBundleShortVersionString ${VERSION}
	plistutil -i $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist -o $(BIN_DIR)/Gorgonzola.app/Contents/Info.plist -s CFBundleVersion ${VERSION}

	# Build project
	GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 go build -o ./$(BIN_DIR)/Gorgonzola.app/Contents/MacOS/gorgonzola cmd/main.go

build: clean
ifeq ($(OS),Darwin)
	echo "Building on macOS"
	$(MAKE) mac-darwin64 mac-darwinarm64
else ifeq ($(OS),Linux)
	echo "Building on Linux"
	$(MAKE) linux-darwin64 linux-darwinarm64
else
	echo "Unsupported OS: $(OS)"
endif


