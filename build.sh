#!/bin/bash
# Exit on any error
set -e

# Clone the Flutter repository from the stable channel
git clone https://github.com/flutter/flutter.git --depth 1 --branch stable /tmp/flutter

# Add the Flutter tool to the path
export PATH="$PATH:/tmp/flutter/bin"

# Enable web support
flutter config --enable-web

# Get project dependencies
flutter pub get

# Build the Flutter web application with a specific base href
flutter build web --release --base-href /
