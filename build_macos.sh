#!/bin/zsh

VERSION='0.8'

# Create macOS .app dir
mkdir -p bin/Gorgonzola.app/Contents/MacOS bin/Gorgonzola.app/Contents/Resources
# Copy app icon
cp macMisc/AppIcon.icns bin/Gorgonzola.app/Contents/Resources
# Copy Info.plist
cp macMisc/Info.plist bin/Gorgonzola.app/Contents
# Set version
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '${VERSION}'" bin/Gorgonzola.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${VERSION}'" bin/Gorgonzola.app/Contents/Info.plist

# Build project
go build -o ./bin/Gorgonzola.app/Contents/MacOS/gorgonzola ./cmd/main.go
