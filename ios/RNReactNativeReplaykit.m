
#import "RNReactNativeReplaykit.h"
#import <React/RCTLog.h>
//#import <AVAssetWriter>

#import "RNReactNativeReplaykit-Swift.h"

@implementation RNReactNativeReplaykit


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(initt)
{
    self.screenRecordCoordinator = [[ScreenRecordCoordinator alloc] init];
}

RCT_EXPORT_METHOD(startRecording:(RCTResponseSenderBlock)callback)
{
    [ReplayFileUtil createReplaysFolder];
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 15];
    for (int i=0; i<15; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }

    [self.screenRecordCoordinator
     startRecordingWithFileName:randomString
     recordingHandler:^(NSError *error) {
         
         if(error)
         {
             
         }
     }
     onCompletion:^(NSError *error) {
         
         if(error)
         {
         }
     }];
}

RCT_EXPORT_METHOD(getRecordings:(RCTResponseSenderBlock)callback)
{
    NSArray *recordings = [self.screenRecordCoordinator listAllReplays];
    callback(@[recordings]);
}

RCT_EXPORT_METHOD(stopRecording)
{
    [self.screenRecordCoordinator stopRecording];
}

RCT_EXPORT_METHOD(previewRecording:(NSString *)path)
{
    [self.screenRecordCoordinator previewRecordingWithFileName:path];
}



RCT_EXPORT_MODULE()

@end
  
