//
//  ScreenRecorder.swift
//  BugReporterTest
//
//  Created by Giridhar on 09/06/17.
//  Copyright © 2017 Giridhar. All rights reserved.
//  Modified By: [
//  Matt Thompson 9/2018
//]

import Foundation
import ReplayKit
import AVKit



@objc class ScreenRecorder:NSObject
{
    var assetWriter:AVAssetWriter!
    var videoInput:AVAssetWriterInput!

    let viewOverlay = WindowUtil()

    //MARK: Screen Recording
    public func startRecording(withFileName fileName: String, recordingHandler:@escaping (Error?)-> Void)
    {
        if #available(iOS 11.0, *)
        {
            let fileURL = URL(fileURLWithPath: ReplayFileUtil.filePath(fileName))
            assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType:
                AVFileTypeMPEG4)
            let videoOutputSettings: Dictionary<String, Any> = [
                AVVideoCodecKey : AVVideoCodecType.h264,
                AVVideoWidthKey : UIScreen.main.bounds.size.width,
                AVVideoHeightKey : UIScreen.main.bounds.size.height
            ];
            
            videoInput  = AVAssetWriterInput (mediaType: AVMediaTypeVideo as String, outputSettings: videoOutputSettings)
            videoInput.expectsMediaDataInRealTime = true
            assetWriter.add(videoInput)
            
            RPScreenRecorder.shared().startCapture(handler: { (sample, bufferType, error) in
                //                print(sample,bufferType,error)
                
                recordingHandler(error)
                
                if CMSampleBufferDataIsReady(sample)
                {
                    if self.assetWriter.status == AVAssetWriterStatus.unknown
                    {
                        self.assetWriter.startWriting()
                        self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sample))
                    }
                    
                    if self.assetWriter.status == AVAssetWriterStatus.failed {
                        print("Error occured, status = \(self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(String(describing: self.assetWriter.error))")
                        return
                    }
                    
                    if (bufferType == .video)
                    {
                        if self.videoInput.isReadyForMoreMediaData
                        {
                            self.videoInput.append(sample)
                        }
                    }
                }
                
            }) { (error) in
                recordingHandler(error)
                //                debugPrint(error)
            }
        } else
        {
            // Fallback on earlier versions
        }
    }

    public func stopRecording(handler: @escaping (Error?) -> Void)
    {
        if #available(iOS 11.0, *)
        {
            RPScreenRecorder.shared().stopCapture
                {    (error) in
                    handler(error)
                    self.assetWriter.finishWriting
                        {
                            print(ReplayFileUtil.fetchAllReplays())
                            
                        }
            }
        } else {
            // Fallback on earlier versions
        }
    }


}


