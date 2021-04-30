Pod::Spec.new do |s|
  s.name                        = "NuveiCashierScanner"
  s.version                     = '0.0.15'
  s.summary                     = "NuveiCashierScanner"
  s.description                 = <<-DESC
                                   Nuvei Cashier Scanner Library
                                  DESC
  s.homepage                    = "https://github.com/SafeChargeInternational/Pods"
  s.license                     = 'Commercial license'
  s.author                      = "Nuvei"
  s.source                      = { :git => "git@github.com:vladnimizhan/Nuvei-Cashier-Card-Scanner-SDK-for-iOS.git", :tag => s.version.to_s }
  s.platform                    = :ios, '10.0'
  s.requires_arc                = true
  s.ios.deployment_target       = "10.0"
  s.swift_version               = '5.1'
  s.libraries                   = 'z'
  s.vendored_frameworks         = "NuveiCashierScanner.framework"
  s.frameworks                  = 'UIKit','WebKit'

  s.dependency 'CodeScanner'

  s.xcconfig =  {
      'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
      'SWIFT_VERSION' => '5.1',
      'OTHER_LDFLAGS' => '$(inherited) -objc -ObjC -lc++ -framework "NuveiCashierScanner"',
      'GCC_SYMBOLS_PRIVATE_EXTERN' => 'YES',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
end
