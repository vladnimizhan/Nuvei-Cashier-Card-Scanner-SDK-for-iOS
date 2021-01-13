Pod::Spec.new do |s|
  s.name                        = "NuveiCashierCardScanner"
  s.version                     = '0.0.14'
  s.summary                     = "NuveiCashierCardScanner"
  s.description                 = <<-DESC
                                   Nuvei Cashier Card Scanner SDK
                                  DESC
  s.homepage                    = "https://github.com/SafeChargeInternational/Nuvei-Cashier-Card-Scanner-SDK-for-iOS"
  s.license                     = './LICENSE.md'
  s.author                      = "Nuvei"
  s.source                      = { :git => "https://github.com/SafeChargeInternational/Nuvei-Cashier-Card-Scanner-SDK-for-iOS.git", :tag => s.version.to_s }
  s.platform                    = :ios, '10.0'
  s.requires_arc                = true
  s.ios.deployment_target       = "10.0"
  s.libraries                   = 'z'
  s.compiler_flags =            "-fmodules"
  s.static_framework            = true
  s.source_files                = 'NuveiCashierCardScanner/*.{h,m}'

  s.dependency 'CardIO'

  s.xcconfig =  {
      'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
      'OTHER_LDFLAGS' => '$(inherited) -objc -ObjC -lc++',
      'GCC_SYMBOLS_PRIVATE_EXTERN' => 'YES',
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FRAMEWORK_VERSION=\"0.0.13\"',
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
end
