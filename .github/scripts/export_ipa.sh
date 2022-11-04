#!/bin/bash

set -eo pipefail

xcodebuild -archivePath $PWD/build/Podcats.xcarchive \
            -exportOptionsPlist .github/secrets/exportOptions.plist \
            -exportPath $PWD/build \
            -allowProvisioningUpdates \
            -exportArchive | xcpretty