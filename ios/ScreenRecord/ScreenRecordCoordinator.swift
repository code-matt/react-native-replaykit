//
//  ScreenRecordCoordinator.swift
//  BugReporterTest
//
//  Created by Giridhar on 21/06/17.
//  Copyright © 2017 Giridhar. All rights reserved.
//  Modified By: [
//  Matt Thompson 9/2018
//]

import Foundation
import AVKit

@objc class ScreenRecordCoordinator: NSObject
{
    let viewOverlay = WindowUtil()
    let screenRecorder = ScreenRecorder()
    var recordCompleted:((Error?) ->Void)?
    let previewDelegateView = PreviewDelegateView()

    override init()
    {
        super.init()
        
        viewOverlay.onStopClick = {
            self.stopRecording()
        }
        
        
    }

    func startRecording(withFileName fileName: String, recordingHandler: @escaping (Error?) -> Void,onCompletion: @escaping (Error?)->Void)
    {
        self.viewOverlay.show()
        screenRecorder.startRecording(withFileName: fileName) { (error) in
            recordingHandler(error)
            self.recordCompleted = onCompletion
        }
    }

    func stopRecording()
    {
        screenRecorder.stopRecording { (error) in
            self.viewOverlay.hide()
            self.recordCompleted?(error)
        }
    }
    
    func previewRecording (withFileName fileURL: String) {
        if UIVideoEditorController.canEditVideo(atPath: fileURL) {
            previewDelegateView.setCoordinator(coordinator: self)
            let rootView = UIApplication.getTopMostViewController()
            let editController = UIVideoEditorController()
            editController.videoPath = fileURL
            editController.delegate = previewDelegateView
            rootView?.present(editController, animated: true, completion: nil)
        } else {
            // handle error with onPreviewError config or something that is one of the init config options
        }
    }

    func listAllReplays() -> Array<String>
    {
        return ReplayFileUtil.fetchAllReplays()
    }


}

class PreviewDelegateView: UIViewController, UINavigationControllerDelegate, UIVideoEditorControllerDelegate {
    
    var coordinator: ScreenRecordCoordinator!
    var isSaved:Bool = false

    func setCoordinator(coordinator: ScreenRecordCoordinator) -> Void {
        self.coordinator = coordinator
    }
    
    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        print("save called")
        if(!self.isSaved) {
            self.isSaved = true
            print("trimmed video saved!")
            editor.dismiss(animated: true, completion: {
                ReplayFileUtil.replaceItem(at: URL(fileURLWithPath: editor.videoPath), with: URL(fileURLWithPath: editedVideoPath))
                self.isSaved = false
            })
        }
    }
}

extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}


//extension FileManager {
//    func replaceWithCopyOfFile(at:URL, with:URL) {
//        do {
//            let url = try self.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: with.deletingPathExtension(), create: true)
//            try self.copyItem(at: with, to: url.appendingPathComponent(with.lastPathComponent))
//
//            let alert = NSAlert()
//            alert.messageText = "Replace \"\(at.lastPathComponent)\" in \"\(at.pathComponents[at.pathComponents.count - 2])\" with new file?"
//            alert.addButton(withTitle: "OK")
//            alert.addButton(withTitle: "Cancel")
//
//            if alert.runModal() == NSAlertFirstButtonReturn {
//                _ = try FileManager.default.replaceItemAt(at, withItemAt: url.appendingPathComponent(with.lastPathComponent))
//            }
//
//            // removes whole temporary directory as a clean up
//            try self.removeItem(at: url)
//        }
//        catch {
//            // error
//            print("unknown error")
//        }
//    }
//}
