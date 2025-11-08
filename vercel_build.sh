#!/bin/bash
set -euxo pipefail

FLUTTER_VERSION=3.35.3
FLUTTER_DIR="$PWD/flutter"

if [ ! -d "$FLUTTER_DIR" ]; then
  curl -L -o flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
  tar -xf flutter.tar.xz
  rm flutter.tar.xz
fi

export PATH="$FLUTTER_DIR/bin:$PATH"
flutter config --enable-web
flutter pub get
flutter build web --release
