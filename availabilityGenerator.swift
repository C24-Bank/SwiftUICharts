#!/usr/bin/swift

import Foundation

//
// MARK: - Configuration
//

let minimumIOSVersion = "14.0"
let rootPath = "."

//
// MARK: - Main Script
//

print("Checking files for missing availability annotations...")

let enumerator = FileManager.default.enumerator(atPath: rootPath)!
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
                newContent += getIndentationString(of: line) // add same indentation to annotation as to line it belongs to
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

//
// MARK: - Helper
//

func getIndentationString(of line: String) -> Substring {
    guard let firstCharacterIndex = line.rangeOfCharacter(from: .whitespacesAndNewlines.inverted)?.lowerBound else {
        return ""
    }
    
    return line[line.startIndex..<firstCharacterIndex]
}
