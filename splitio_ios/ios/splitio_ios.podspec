#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint splitio_ios.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'splitio_ios'
  s.version          = '1.2.0'
  s.summary          = 'split.io official Flutter plugin.'
  s.description      = <<-DESC
split.io official Flutter plugin.
                       DESC
  s.homepage         = 'http://split.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Split' => 'support@split.io' }
  s.source           = { :path => '.' }
  s.source_files = 'splitio_ios/Sources/splitio_ios/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'Split', '~> 3.6.0'
  s.platform = :ios, '12.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
