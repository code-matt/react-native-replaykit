//  Created by Giridhar on 21/06/17.
//  MIT Licence.
//  Modified By: [
//  Matt Thompson 9/14/18
//]

import Foundation
import AVKit

@objc class ScreenRecordCoordinator: NSObject
{
    let viewOverlay = WindowUtil()
    let screenRecorder = ScreenRecorder()
    var recordCompleted:((Error?) ->Void)?
    let previewDelegateView = PreviewDelegateView()
    var showOverlay: Bool?

    init(showOverlay: Bool)
    {
        super.init()
        self.showOverlay = showOverlay
        
        viewOverlay.onStopClick = {
            self.stopRecording()
        }
    }

    func startRecording(withFileName fileName: String, recordingHandler: @escaping (Error?) -> Void,onCompletion: @escaping (Error?)->Void)
    {
        if (self.showOverlay!) {
            self.viewOverlay.show()
        }
        screenRecorder.startRecording(withFileName: fileName) { (error) in
            recordingHandler(error)
            self.recordCompleted = onCompletion
        }
    }

    func stopRecording()
    {
        screenRecorder.stopRecording { (error) in
            if (self.showOverlay!) {
                self.viewOverlay.hide()
            }
            self.recordCompleted?(error)
        }
    }
    
    func removeRecording(withFilePath fileURL: String)
    {
        ReplayFileUtil.deleteItem(at: URL(fileURLWithPath: fileURL))
    }
    
    func copyRecording(withFilePath fileURL: String, destFileURL: String)
    {
        ReplayFileUtil.copyItem(at: URL(fileURLWithPath: fileURL), to: URL(fileURLWithPath: destFileURL))
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
