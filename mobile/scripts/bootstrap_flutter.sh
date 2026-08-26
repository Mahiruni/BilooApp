#!/usr/bin/env bash
set -euo pipefail
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK is required: https://docs.flutter.dev/get-started/install"
  exit 1
fi
cp lib/main.dart /tmp/biloo_main.dart
cp pubspec.yaml /tmp/biloo_pubspec.yaml
flutter create . --platforms=android,ios,web --project-name=biloo --org=com.biloo
cp /tmp/biloo_main.dart lib/main.dart
cp /tmp/biloo_pubspec.yaml pubspec.yaml
flutter pub get
flutter analyze
