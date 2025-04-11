#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint voip24h_sdk_mobile.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'voip24h_sdk_mobile'
  s.version          = '0.0.2'
  s.summary          = 'Flutter Voip24h-SDK Mobile'
  s.description      = <<-DESC
Flutter Voip24h-SDK Mobile
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Voip24h' => 'phat.nguyen@voip24h.vn' }
  s.source           = { :path => '.' }
#   s.source           = { :http => "https://dlp.voip24h.vn/voip-callkit.zip" }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.prepare_command = <<-CMD
    curl -O https://dlp.voip24h.vn/voip-callkit.zip
    unzip -o voip-callkit.zip -d voip-callkit
  CMD

  s.vendored_frameworks = "voip-callkit/apple-darwin/Frameworks/**"

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', 'VALID_ARCHS' => "arm64 armv7 x86_64" }
  s.swift_version = '5.0'

  s.subspec 'all-frameworks' do |sp|
    sp.vendored_frameworks = "voip-callkit/apple-darwin/Frameworks/**"
  end

  s.subspec 'basic-frameworks' do |sp|
    sp.dependency 'voip24h_sdk_mobile/app-extension'
    sp.vendored_frameworks = "voip-callkit/apple-darwin/Frameworks/{bctoolbox-ios.framework}"
  end

  s.subspec 'app-extension' do |sp|
    sp.vendored_frameworks = "voip-callkit/apple-darwin/Frameworks/{bctoolbox.framework,belcard.framework,belle-sip.framework,belr.framework,lime.framework,linphone.framework,mediastreamer2.framework,msamr.framework,mscodec2.framework,msopenh264.framework,mssilk.framework,mswebrtc.framework,msx264.framework,ortp.framework}"
  end

  s.subspec 'app-extension-swift' do |sp|
    sp.source_files = "voip-callkit/apple-darwin/share/linphonesw/*.swift"
    sp.dependency "voip24h_sdk_mobile/app-extension"
    sp.framework = 'linphone', 'belle-sip', 'bctoolbox'
  end

  s.subspec 'swift' do |sp|
    sp.dependency "voip24h_sdk_mobile/basic-frameworks"
    sp.dependency "voip24h_sdk_mobile/app-extension-swift"
    sp.framework = 'bctoolbox-ios'
  end
end
