#!/usr/bin/swift

import Foundation

let rootPath = "../.."

let enumerator = FileManager.default.enumerator(atPath: rootPath)!

print("Checking files for missing availability annotations...")
for file in enumerator {
    let completePath = rootPath + "/" + (file as! String)
    let fileURL = URL(fileURLWithPath: completePath)
    
    if fileURL.pathExtension.lowercased() == "swift" {
        let contentData = try! Data(contentsOf: fileURL)
        let content = String(data: contentData, encoding: .utf8)!
        var newContent = ""
        var changes = 0
        content.enumerateLines { line, stop in
            var lineCopy = line
            lineCopy = lineCopy.replacingOccurrences(of: "public", with: "")
            lineCopy = lineCopy.replacingOccurrences(of: "internal", with: "")
            lineCopy = lineCopy.replacingOccurrences(of: "final", with: "")
            lineCopy = lineCopy.trimmingCharacters(in: .whitespacesAndNewlines)
            if lineCopy.starts(with: "class") || lineCopy.starts(with: "struct") || lineCopy.starts(with: "extension") || lineCopy.starts(with: "enum") || lineCopy.starts(with: "protocol") || lineCopy.starts(with: "typealias") {
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
print("Done.")
