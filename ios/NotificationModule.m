#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface
RCT_EXTERN_MODULE(MyNativeModules, NSObject)
RCT_EXTERN_METHOD(onNotification)
RCT_EXTERN_METHOD(requestNotificationPermission)
@end
