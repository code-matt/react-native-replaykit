//  Created by Matt Thompson on 9/14/18.
//  MIT Licence.

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <ReplayKit/ReplayKit.h>
#import "RNReactNativeReplaykit-Swift.h"


@interface RNReactNativeReplaykit : NSObject <RCTBridgeModule>

@property (strong, nonatomic) RPScreenRecorder *screenRecorder;
@property (strong, nonatomic) RPPreviewViewController *previewViewController;
@property (strong, nonatomic) ScreenRecordCoordinator *screenRecordCoordinator;

@end
  
