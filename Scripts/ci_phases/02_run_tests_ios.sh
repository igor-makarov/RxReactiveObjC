#!/bin/sh
mkdir -p build || true
set -o pipefail && \
xcodebuild test \
    -workspace RxReactiveObjC.xcworkspace \
    -scheme RxReactiveObjCTests \
    -sdk iphonesimulator \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 8,OS=latest' \
| tee build/tests_ios.txt \
| bundle exec xcpretty