#!/bin/bash

set -eo pipefail

xcodebuild -workspace PodcatsAppiOS/PodcatsAppiOS.xcworkspace \
            -scheme Podcats\ iOS \
            -sdk iphoneos \
            -configuration AppStoreDistribution \
            -archivePath $PWD/build/Podcats.xcarchive \
            clean archive | xcpretty