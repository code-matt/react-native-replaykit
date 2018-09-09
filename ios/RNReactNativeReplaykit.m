
#import "RNReactNativeReplaykit.h"
#import <React/RCTLog.h>
// TODO: For storing the videos in app's documents
//#define documentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation RNReactNativeReplaykit

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(startRecording)
{
    self.screenRecorder = [RPScreenRecorder sharedRecorder];
    [self.screenRecorder startRecordingWithHandler:^(NSError * _Nullable error) {
        
    }];
}

RCT_EXPORT_METHOD(stopRecording)
{
    [self.screenRecorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        self.previewViewController = previewViewController;
        [controller presentViewController:self.previewViewController animated:true completion:nil];
    }];
}

RCT_EXPORT_MODULE()

@end
  
