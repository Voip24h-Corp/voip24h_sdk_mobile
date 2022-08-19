#import "Voip24hSdkMobilePlugin.h"
#if __has_include(<voip24h_sdk_mobile/voip24h_sdk_mobile-Swift.h>)
#import <voip24h_sdk_mobile/voip24h_sdk_mobile-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "voip24h_sdk_mobile-Swift.h"
#endif

@implementation Voip24hSdkMobilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVoip24hSdkMobilePlugin registerWithRegistrar:registrar];
}
@end
