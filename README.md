# Nuvei Cashier Card Scanner SDK for iOS

## SETUP
### If you use [CocoaPods](https://cocoapods.org/)

Add the next line to the dependencies list in your Podfile:
```ruby
pod 'NuveiCashierCardScanner'
```

Add the next block in the end of your app's target dependencies: 
```ruby
pre_install do |installer|
  # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
  Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end
```

Next is a sample Podfile with all the additions above:
```ruby
platform :ios, '10.0'
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/SafeChargeInternational/Pods.git'

target 'NuveiCashierCardScannerExample' do
  pod 'NuveiCashierCardScanner', '~> 1.0'

  pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
  end
end

```

## USAGE
Import the SDK module:
```swift
import NuveiCashierCardScanner
```

The SDK works with WKWebView, so add the next line before you load Nuvei cashier page in the web view:
```swift
NuveiCashierCardScanner.connect(to: webView)
```

## LICENSE
See [license](https://cocoapods.org/)

## ACKNOWLEDGEMENTS
This SDK depends on card-io, so please follow the next requirements by card-io:
* Add [card.io's open source license acknowledgments](https://github.com/card-io/card.io-iOS-SDK/blob/master/acknowledgments.md) to [your app's acknowledgments](https://stackoverflow.com/questions/3966116/where-to-put-open-source-credit-information-for-an-iphone-app).
* Refer to the header files for more usage options and information.
* You should add the key [NSCameraUsageDescription](https://developer.apple.com/library/prerelease/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW24) to your app's Info.plist and set the value to be a string describing why your app needs to use the camera (e.g. "To scan credit cards."). This string will be displayed when the app initially requests permission to access the camera.

## HINTS & TIPS
* Processing images can be memory intensive, so make sure to test that your app properly handles memory warnings.
* For your users' security, [obscure your app's cached screenshots](https://viaforensics.com/resources/reports/best-practices-ios-android-secure-mobile-development/ios-avoid-cached-application-snapshots/) while the payment web view is displayed.
