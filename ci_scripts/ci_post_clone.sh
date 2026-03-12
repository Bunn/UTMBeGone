#!/bin/sh

# Xcode Cloud overrides CURRENT_PROJECT_VERSION with its own counter.
# This script adds an offset so build numbers stay above previous releases.
# Last manual build number: 16 (2.0.0)
BUILD_NUMBER_OFFSET=16

NEW_BUILD_NUMBER=$(($CI_BUILD_NUMBER + $BUILD_NUMBER_OFFSET))

echo "Setting build number to $NEW_BUILD_NUMBER (CI_BUILD_NUMBER=$CI_BUILD_NUMBER + offset=$BUILD_NUMBER_OFFSET)"

xcrun agvtool new-version -all $NEW_BUILD_NUMBER
