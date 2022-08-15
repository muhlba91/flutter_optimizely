#import "FlutterOptimizelyPlugin.h"
#if __has_include(<flutter_optimizely/flutter_optimizely-Swift.h>)
#import <flutter_optimizely/flutter_optimizely-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_optimizely-Swift.h"
#endif

@implementation FlutterOptimizelyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterOptimizelyPlugin registerWithRegistrar:registrar];
}
@end
