//  Created by Giridhar on 20/06/17.
//  MIT Licence.
//  Modified By: [
//  Matt Thompson 9/14/18
//]


import Foundation

@objc public class ReplayFileUtil:NSObject
{
    class func createReplaysFolder()
    {
        // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let replayDirectoryPath = documentDirectoryPath.appending("/Replays")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: replayDirectoryPath) {
                print("Creating replays dir...")
                do {
                    try fileManager.createDirectory(atPath: replayDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                    
                } catch {
                    print("Error creating Replays folder in documents dir: \(error)")
                }
            }
        }
    }
    
    class func replaceItem(at dstURL: URL, with srcURL: URL) {
        do {
            try FileManager.default.removeItem(at: dstURL)
            self.copyItem(at: srcURL, to: dstURL)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    class func copyItem(at srcURL: URL, to dstURL: URL) {
        do {
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch let error as NSError {
            if error.code == NSFileWriteFileExistsError {
                print("File exists. Trying to replace")
                self.replaceItem(at: dstURL, with: srcURL)
            }
        }
    }
    
    class func deleteItem(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error as NSError {
            print("Error deleting file!")
        }
    }

    class func filePath(_ fileName: String) -> String
    {
        createReplaysFolder()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filePath : String = "\(documentsDirectory)/Replays/\(fileName).mp4"
        return filePath
    }
    
    class func fetchAllReplays() -> Array<String>
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let replayPath = documentsDirectory?.appendingPathComponent("/Replays")
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: replayPath!, includingPropertiesForKeys: nil, options: [])
        let urls = directoryContents.map({
            (url: URL) -> String in
            return url.relativePath
        })
        return urls
    }
}

