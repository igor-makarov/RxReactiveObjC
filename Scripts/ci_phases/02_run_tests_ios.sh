#!/bin/sh
mkdir -p build || true
set -o pipefail && \
xcodebuild test \
    -workspace RxReactiveObjC.xcworkspace \
    -scheme RxReactiveObjCTests \
    -sdk iphonesimulator \
    -configuration Debug \
    -destination 'platform=iOS Simulator,iPhone 15 Pro,OS=latest' \
| tee build/tests_ios.txt \
| bundle exec xcpretty