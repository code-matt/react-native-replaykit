
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <ReplayKit/ReplayKit.h>
//#import "RNReactNativeReplaykit-Swift.h"
//@class ReplayFileUtil;


@interface RNReactNativeReplaykit : NSObject <RCTBridgeModule>

@property (strong, nonatomic) RPScreenRecorder *screenRecorder;
@property (strong, nonatomic) AVAssetWriter *assetWriter; // TODO
@property (strong, nonatomic) AVAssetWriterInput *assetWriterInput; // TODO
@property (strong, nonatomic) RPPreviewViewController *previewViewController;

@end
  
