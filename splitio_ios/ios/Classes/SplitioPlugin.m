#import "SplitioPlugin.h"
#if __has_include(<splitio_ios/splitio_ios-Swift.h>)
#import <splitio_ios/splitio_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "splitio_ios-Swift.h"
#endif

@implementation SplitioPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSplitioPlugin registerWithRegistrar:registrar];
}
@end
