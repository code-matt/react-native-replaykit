//  Created by Giridhar on 09/06/17.
//  MIT Licence.
//  Modified By: [
//  Matt Thompson 9/14/18
//]

import Foundation
import ReplayKit
import AVKit

@objcMembers

class ScreenRecorder:NSObject
{
    var assetWriter:AVAssetWriter!
    var finishCalled = false;
    var videoInput:AVAssetWriterInput!
    var audioInput:AVAssetWriterInput!
    var micInput:AVAssetWriterInput!
    let viewOverlay = WindowUtil()
    
    public func startRecording(withFileName fileName: String, recordingHandler:@escaping (Error?)-> Void)
    {
        self.finishCalled = false
        if #available(iOS 11.0, *)
        {
            let fileURL = URL(fileURLWithPath: ReplayFileUtil.filePath(fileName))
            assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType:
                AVFileType.mov)
            let videoOutputSettings: Dictionary<String, Any> = [
                AVVideoCodecKey : AVVideoCodecType.h264,
                AVVideoWidthKey : UIScreen.main.bounds.size.width,
                AVVideoHeightKey : UIScreen.main.bounds.size.height
            ];
            
            var channelLayout = AudioChannelLayout.init()
            channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo
            let audioOutputSettings: [String : Any] = [
                AVNumberOfChannelsKey: 2,
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100,
                AVChannelLayoutKey: NSData(bytes: &channelLayout, length: MemoryLayout.size(ofValue: channelLayout)),
            ]
            
            let micAudioOutputSettings: [String : Any] = [
                AVNumberOfChannelsKey: 2,
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false,
                AVLinearPCMIsNonInterleaved: false,
                AVSampleRateKey: 44100.0,
            ]
            
            videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
            audioInput  = AVAssetWriterInput(mediaType: AVMediaType.audio,outputSettings: audioOutputSettings)
            micInput  = AVAssetWriterInput(mediaType: AVMediaType.audio,outputSettings: micAudioOutputSettings)
            
            videoInput.expectsMediaDataInRealTime = true
            audioInput.expectsMediaDataInRealTime = true
            micInput.expectsMediaDataInRealTime = true
            
            assetWriter.add(videoInput)
            assetWriter.add(audioInput)
            assetWriter.add(micInput)
            RPScreenRecorder.shared().isMicrophoneEnabled = true;
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            } catch let error as NSError {
                print(error)
            }
            
            RPScreenRecorder.shared().startCapture(handler: { (sample, bufferType, error) in
                
                recordingHandler(error)
                
                if CMSampleBufferDataIsReady(sample) && !self.finishCalled
                {
                    if self.assetWriter.status == AVAssetWriter.Status.unknown
                    {
                        self.assetWriter.startWriting()
                        self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sample))
                    }
                    
                    if self.assetWriter.status == AVAssetWriter.Status.failed {
                        print("Error occured, status = \(self.assetWriter.status.rawValue), \(self.assetWriter.error!.localizedDescription) \(String(describing: self.assetWriter.error))")
                        return
                    }
                    
                    if (bufferType == .video && self.assetWriter.status != AVAssetWriter.Status.completed)
                    {
                        if self.videoInput.isReadyForMoreMediaData
                        {
                            self.videoInput.append(sample)
                        }
                    }
                    
                    if (bufferType == .audioApp && self.assetWriter.status != AVAssetWriter.Status.completed)
                    {
                        if self.audioInput.isReadyForMoreMediaData
                        {
                            self.audioInput.append(sample)
                        }
                    }
                    
                    if (bufferType == .audioMic && self.assetWriter.status != AVAssetWriter.Status.completed)
                    {
                        if self.micInput.isReadyForMoreMediaData
                        {
                            self.micInput.append(sample)
                        }
                    }
                }
                
            }) { (error) in
                recordingHandler(error)
            }
        } else
        {
            // Fallback on earlier versions
        }
    }
    
    public func stopRecording(handler: @escaping (Error?) -> Void)
    {
        self.finishCalled = true
        if #available(iOS 11.0, *)
        {
            RPScreenRecorder.shared().stopCapture { (Error) in
                //                self.micInput.markAsFinished()
                self.assetWriter.finishWriting {
                    print(ReplayFileUtil.fetchAllReplays())
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
}


