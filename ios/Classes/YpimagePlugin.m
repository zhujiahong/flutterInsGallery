#import "YpimagePlugin.h"
#if __has_include(<ypimage/ypimage-Swift.h>)
#import <ypimage/ypimage-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ypimage-Swift.h"
#endif

@implementation YpimagePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYpimagePlugin registerWithRegistrar:registrar];
}
@end
