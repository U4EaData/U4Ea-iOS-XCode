#!/bin/sh

set -o pipefail && xcodebuild \
-workspace u4ea.xcworkspace \
-scheme u4ea \
-destination 'platform=iOS Simulator,name=iPhone 6,OS=10.2' \
build test | xcpretty --test --color
