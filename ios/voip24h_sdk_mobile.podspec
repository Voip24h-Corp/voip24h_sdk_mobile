#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint voip24h_sdk_mobile.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'voip24h_sdk_mobile'
  s.version          = '0.0.7'
  s.summary          = 'Flutter Voip24h-SDK Mobile'
  s.description      = <<-DESC
Flutter Voip24h-SDK Mobile
                       DESC
  s.homepage         = 'https://voip24h.vn/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Voip24h' => 'phat.nguyen@voip24h.vn' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'voip-callkit/apple-darwin/share/linphonesw/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.prepare_command = <<-CMD
    curl -O https://dlp.voip24h.vn/voip-callkit-v2.zip
    unzip -o voip-callkit-v2.zip -d voip-callkit
  CMD

  s.vendored_frameworks = "voip-callkit/apple-darwin/XCFrameworks/**"

  # Flutter.framework does not contain a i386 slice.
#   s.pod_target_xcconfig = {
#     'DEFINES_MODULE' => 'YES',
#     'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
#     'VALID_ARCHS' => "arm64 armv7 x86_64"
#   }
#   s.user_target_xcconfig = {
#     'VALID_ARCHS' => "arm64 armv7 x86_64"
#   }
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'VALID_ARCHS' => 'arm64 x86_64',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PODS_ROOT)/../voip-callkit/apple-darwin/XCFrameworks"',
    'OTHER_LDFLAGS' => '$(inherited) -framework "bctoolbox" -framework "belle-sip" -framework "belr" -framework "belcard" -framework "ortp" -framework "mediastreamer2" -framework "lime" -framework "linphone"',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }

  s.user_target_xcconfig = {
    'VALID_ARCHS' => 'arm64 x86_64',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PODS_ROOT)/../voip-callkit/apple-darwin/XCFrameworks"'
  }
  s.swift_version = '5.0'

#   s.subspec 'all-frameworks' do |sp|
#     sp.vendored_frameworks = "voip-callkit/apple-darwin/XCFrameworks/**"
#   end
#
#   s.subspec 'basic-frameworks' do |sp|
#     sp.dependency 'voip24h_sdk_mobile/app-extension'
#     sp.vendored_frameworks = "voip-callkit/apple-darwin/XCFrameworks/{bctoolbox-ios.xcframework}"
#   end
#
#   s.subspec 'app-extension' do |sp|
#     sp.vendored_frameworks = "voip-callkit/apple-darwin/XCFrameworks/{bctoolbox.xcframework,belcard.xcframework,belle-sip.xcframework,belr.xcframework,lime.xcframework,linphone.xcframework,mediastreamer2.xcframework,msamr.xcframework,mscodec2.xcframework,msopenh264.xcframework,mssilk.xcframework,ortp.xcframework}"
#   end
#
#   s.subspec 'app-extension-swift' do |sp|
#     sp.source_files = "voip-callkit/apple-darwin/share/linphonesw/*.swift"
#     sp.dependency "voip24h_sdk_mobile/app-extension"
#     sp.framework = 'linphone', 'belle-sip', 'bctoolbox'
#   end
#
#   s.subspec 'swift' do |sp|
#     sp.dependency "voip24h_sdk_mobile/basic-frameworks"
#     sp.dependency "voip24h_sdk_mobile/app-extension-swift"
#     sp.framework = 'bctoolbox-ios'
#   end
end