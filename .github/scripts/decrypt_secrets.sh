#!/bin/sh
set -eo pipefail

gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_KEY" --output ./.github/secrets/com.podcats.app.product.iOS.mobileprovision ./.github/secrets/com.podcats.app.product.iOS.mobileprovision.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_KEY" --output ./.github/secrets/com.podcats.app.product.iOS.p12 ./.github/secrets/com.podcats.app.product.iOS.p12.gpg

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./.github/secrets/com.podcats.app.product.iOS.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/com.podcats.app.product.iOS.mobileprovision


security create-keychain -p "" build.keychain
security import ./.github/secrets/com.podcats.app.product.iOS.p12 -t agg -k ~/Library/Keychains/build.keychain -P "" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain