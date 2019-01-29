#!/bin/sh -l +o xtrace
set -o pipefail && \
xcodebuild test \
    -workspace RxReactiveObjC.xcworkspace \
    -scheme RxReactiveObjCTests \
    -sdk iphonesimulator \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 8,OS=latest' \
| tee build/tests_ios.txt \
| xcpretty