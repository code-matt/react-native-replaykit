//  Created by Matt Thompson on 9/14/18.
//  MIT Licence.

#import "RNReactNativeReplaykit.h"
#import <React/RCTLog.h>

#import "RNReactNativeReplaykit-Swift.h"

@implementation RNReactNativeReplaykit


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(initialize)
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
             callback(@[[NSNull null], error.localizedDescription]);
         }
     }
     onCompletion:^(NSError *error) {
         if(error)
         {
             callback(@[[NSNull null], error.localizedDescription]);
         } else {
             NSArray *recordings = [self.screenRecordCoordinator listAllReplays];
             callback(@[recordings, [NSNull null]]);
         }
     }];
}

RCT_EXPORT_METHOD(deleteRecording:(NSString *)path callback:(RCTResponseSenderBlock)callback)
{
    [self.screenRecordCoordinator removeRecordingWithFilePath:path];
    NSArray *recordings = [self.screenRecordCoordinator listAllReplays];
    callback(@[recordings, path]);
}

RCT_EXPORT_METHOD(copyRecording:(NSString *)path callback:(RCTResponseSenderBlock)callback)
{
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 15];
    for (int i=0; i<15; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    NSString *newPath = [[NSString stringWithFormat:@"%@/%@",
                          [path stringByDeletingLastPathComponent], randomString]
                         stringByAppendingPathExtension:[path pathExtension]];
    
    [self.screenRecordCoordinator copyRecordingWithFilePath:path destFileURL:newPath];
    NSArray *recordings = [self.screenRecordCoordinator listAllReplays];
    
    callback(@[recordings, newPath]);
}

RCT_EXPORT_METHOD(getRecordings:(RCTResponseSenderBlock)callback)
{
    NSArray *recordings = [self.screenRecordCoordinator listAllReplays];
    callback(@[recordings]);
}

RCT_EXPORT_METHOD(stopRecording:(RCTResponseSenderBlock)callback)
{
    [self.screenRecordCoordinator stopRecording];
    NSArray *recordings = [self.screenRecordCoordinator listAllReplays];
    callback(@[recordings]);
    
}

RCT_EXPORT_METHOD(previewRecording:(NSString *)path)
{
    [self.screenRecordCoordinator previewRecordingWithFileName:path];
}



RCT_EXPORT_MODULE()

@end
  
