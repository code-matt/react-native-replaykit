
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#import <ReplayKit/ReplayKit.h>


@interface RNReactNativeReplaykit : NSObject <RCTBridgeModule>

@property (strong, nonatomic) RPScreenRecorder *screenRecorder;
@property (strong, nonatomic) AVAssetWriter *assetWriter;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterInput;
@property (strong, nonatomic) RPPreviewViewController *previewViewController;

@end
  
