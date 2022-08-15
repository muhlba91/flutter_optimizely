Pod::Spec.new do |s|
  s.name             = 'flutter_optimizely'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for Optimizely.'
  s.description      = <<-DESC
Flutter plugin for Optimizely.
                       DESC
  s.homepage         = 'https://github.com/muhlba91/flutter_optimizely'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Daniel Muehlbachler-Pietrzykowski' => 'daniel.muehlbachler@niftyside.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'OptimizelySwiftSDK', '~> 3.10.1'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
