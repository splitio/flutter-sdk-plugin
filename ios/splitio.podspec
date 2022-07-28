#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint splitio.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'splitio'
  s.version          = '0.0.1'
  s.summary          = 'split.io official Flutter plugin.'
  s.description      = <<-DESC
split.io official Flutter plugin.
                       DESC
  s.homepage         = 'http://split.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Split' => 'support@split.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Split', '~> 2.15.0'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
