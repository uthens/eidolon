fastlane documentation
================
# Installation
```
sudo gem install fastlane
```
# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Run all iOS tests on an iPad
### ios oss
```
fastlane ios oss
```
Set all the API keys required for distribution
### ios deploy
```
fastlane ios deploy
```
Release a new beta version on Hockey

This action does the following:



- Verifies API keys are non-empty

- Ensures a clean git status

- Increment the build number

- Build and sign the app

- Upload the ipa file to hockey

- Post a message to slack containing the download link

- Commit and push the version bump
### ios storyboard_ids
```
fastlane ios storyboard_ids
```
Updates the storyboard identifier Swift values.

----

This README.md is auto-generated and will be re-generated every time to run [fastlane](https://fastlane.tools)
More information about fastlane can be found on [https://fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [GitHub](https://github.com/fastlane/fastlane)