
#import "RNReactNativeReplaykit.h"
#import <React/RCTLog.h>

#import "RNReactNativeReplaykit-Swift.h"

@implementation RNReactNativeReplaykit


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(startRecording)
{
    [ReplayFileUtil createReplaysFolder];
//    [ScreenRecorder start]
}

RCT_EXPORT_METHOD(getRecordings:(RCTResponseSenderBlock)callback)
{
    NSArray *recordings = [ReplayFileUtil fetchAllReplays];
    callback(@[[NSNull null], recordings]);
}

RCT_EXPORT_METHOD(stopRecording)
{
}

RCT_EXPORT_MODULE()

@end
  
