#!/bin/sh
rm -Rf ios/Pods
rm -Rf ios/.symlink
rm -Rf ios/Flutter/Flutter.framework
rm -Rf ios/Flutter/Flutter.podspec
rm -rf ios/Podfile.lock
rm pubspec.lock
flutter clean
flutter packages get
cd ios
pod install
pod update
cd ..