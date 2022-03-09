#!/usr/bin/swift

import Foundation

let rootPath = "../../Sources"

let enumerator = FileManager.default.enumerator(atPath: rootPath)!

for file in enumerator {
    let completePath = rootPath + "/" + (file as! String)
    let fileURL = URL(fileURLWithPath: completePath)
//    print("Looking at \(fileURL.absoluteString)")
    
    if fileURL.pathExtension.lowercased() == "swift" {
        let contentData = try! Data(contentsOf: fileURL)
        let content = String(data: contentData, encoding: .utf8)!
        var newContent = ""
        var changes = 0
        content.enumerateLines { line, stop in
            if line.starts(with: "class") || line.starts(with: "struct") || line.starts(with: "extension") {
//                print(line)
                newContent += "@available(iOS 14.0, *)\n"
                changes += 1
                
            }
            
            newContent += line + "\n"
        }
        
        if changes > 0 {
            try! newContent.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Made \(changes) changes to \(fileURL.absoluteString)")
        }
    }
}
