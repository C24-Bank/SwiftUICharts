#!/usr/bin/swift

import Foundation

let minimumIOSVersion = "14.0"
let rootPath = "../.."

let enumerator = FileManager.default.enumerator(atPath: rootPath)!

print("Checking files for missing availability annotations...")
var totalChanges = 0
for file in enumerator {
    let completePath = rootPath + "/" + (file as! String)
    let fileURL = URL(fileURLWithPath: completePath)
    
    if fileURL.pathExtension.lowercased() == "swift" {
        let contentData = try! Data(contentsOf: fileURL)
        let content = String(data: contentData, encoding: .utf8)!
        var newContent = ""
        var changes = 0
        content.enumerateLines { line, _ in
            // Remove existing annotations (by not adding them to newContent). They will be re-added below. This is
            // done to avoid duplicate annotations and to update annotations in case minimumIOSVersion changed
            if line.trimmingCharacters(in: .whitespacesAndNewlines).starts(with: "@available(iOS ") {
                return
            }
            
            var lineCopy = line
            lineCopy = lineCopy.replacingOccurrences(of: "public", with: "")
            lineCopy = lineCopy.replacingOccurrences(of: "internal", with: "")
            lineCopy = lineCopy.replacingOccurrences(of: "final", with: "")
            lineCopy = lineCopy.trimmingCharacters(in: .whitespacesAndNewlines)
            if lineCopy.starts(with: "class") || lineCopy.starts(with: "struct") || lineCopy.starts(with: "extension") || lineCopy.starts(with: "enum") || lineCopy.starts(with: "protocol") || lineCopy.starts(with: "typealias") {
                let test = line.rangeOfCharacter(from: .whitespacesAndNewlines.inverted)
                let test2 = line[line.startIndex..<test!.lowerBound]
//                let test2 = line.distance(from: line.startIndex, to: test!.lowerBound)
//                newContent += (0..<test2).reduce("", { lol, _ in lol + " " })
//                newContent += test2
                newContent += "@available(iOS \(minimumIOSVersion), *)\n"
                changes += 1
                totalChanges += 1
            }
            
            newContent += line + "\n"
        }
        
        if changes > 0 {
            try! newContent.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Added \(changes) annotations to \(fileURL.absoluteString)")
        }
    }
}
print("Done (\(totalChanges) annotations added).")
