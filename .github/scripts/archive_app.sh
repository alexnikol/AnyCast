#!/bin/bash

set -eo pipefail

xcodebuild -workspace PodcatsAppiOS/PodcatsAppiOS.xcworkspace \
            -scheme Podcats \
            -sdk iphoneos \
            -configuration Release \
            -derivedDataPath "DerivedData" \
            -archivePath "DerivedData/Archive/EssentialApp.xcarchive" \
            clean archive | xcpretty