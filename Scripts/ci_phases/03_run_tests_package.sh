#!/bin/sh
mkdir -p build || true

set -o pipefail
set -e

rm -rf RxReactiveObjC.xcodeproj RxReactiveObjC.xcworkspace

case "$TEST_COMMAND" in
  swiftpm)
    swift test
    ;;
  xc-macos)
    xcodebuild test \
      -scheme RxReactiveObjC \
      -destination 'platform=macOS' \
    | tee build/log.txt \
    | bundle exec xcpretty
    ;;
  xc-ios)
    xcodebuild test \
      -scheme RxReactiveObjC \
      -sdk iphonesimulator \
      -destination 'platform=iOS Simulator,name=iPhone 15 Pro,OS=latest' \
    | tee build/log.txt \
    | bundle exec xcpretty
    ;;
  *)
    echo "Unknown test command"
    exit 1
    ;;
esac
