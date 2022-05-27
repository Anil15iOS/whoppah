fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios local_test
```
fastlane ios local_test
```
[LOCAL] Build and run tests
### ios test
```
fastlane ios test
```
Build and run tests
### ios upload_metadata
```
fastlane ios upload_metadata
```
Uploads metadata only - no ipa file will be uploaded

You'll get a summary of the collected metadata before it's uploaded
### ios release
```
fastlane ios release
```
Push a new release build to the App Store
### ios testflight_release
```
fastlane ios testflight_release
```
Push a new release build to Testflight
### ios update_lokalise
```
fastlane ios update_lokalise
```
Update lokalise
### ios test_releasenotes
```
fastlane ios test_releasenotes
```
View release notes text
### ios staging
```
fastlane ios staging
```
Push a new beta/staging release to Crashlytics
### ios beta
```
fastlane ios beta
```
Push a new beta/testing release to Crashlytics

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
