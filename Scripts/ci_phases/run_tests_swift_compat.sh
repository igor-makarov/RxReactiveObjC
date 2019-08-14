#!/bin/sh -l +o xtrace

set -o pipefail && \
xcodebuild build \
    -workspace RxReactiveObjC.xcworkspace \
    -scheme RxReactiveObjCSwiftCompat \
    -configuration Release \
    -destination 'generic/platform=iOS' \
| tee build/build_ios.txt \
| xcpretty

set -o pipefail && \
xcodebuild test \
    -workspace RxReactiveObjC.xcworkspace \
    -scheme RxReactiveObjCSwiftCompat \
    -sdk iphonesimulator \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=latest' \
| tee build/tests_ios.txt \
| xcpretty