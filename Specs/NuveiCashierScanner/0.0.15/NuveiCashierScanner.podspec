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
  s.libraries                   = 'z'
  s.vendored_frameworks         = "NuveiCashierScanner.framework"
  s.frameworks                  = 'UIKit','WebKit'

  s.dependency 'CodeScanner'
end
