Pod::Spec.new do |s|
  s.name                        = "NuveiCashierCardScanner"
  s.version                     = '0.0.15'
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
end
