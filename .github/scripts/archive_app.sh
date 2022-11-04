#!/bin/bash

set -eo pipefail

xcodebuild -workspace PodcatsAppiOS/PodcatsAppiOS.xcworkspace \
            -scheme Podcats \
            -sdk iphoneos \
            -configuration "Release" \
            -archivePath $PWD/build/Podcats.xcarchive \
            clean archive | xcpretty