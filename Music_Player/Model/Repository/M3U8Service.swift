//
//  M3U8Service.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/04.
//

import Foundation

class M3U8Service {
    //create
    static func createM3U8(folderPath: String, fileName: String) -> Bool {
        let filePath = "\(folderPath)/" + "\(fileName).m3u8"
        let content = "#EXTM3U\n" + "#\(fileName)"
        return FileService.createFile(filePath: filePath, content: content)
    }
    
    //check
    static func isExistM3U8(filePath: String) -> Bool {
        FileService.isExistFile(filePath: filePath)
    }
    
    //get
    static func getM3U8Components(filePath: String) -> [String] {
        guard let content = FileService.getFileContent(filePath: filePath) else { return [] }
        return content.components(separatedBy: "\n")
    }
    
    //update
    static func addMusic(M3U8FilePath: String, musicFilePath: String) -> Bool {
        var components = getM3U8Components(filePath: M3U8FilePath)
        components.append(musicFilePath)
        let newContent = components.joined(separator: "\n")
        return FileService.updateFile(filePath: M3U8FilePath, content: newContent)
    }
    
    static func renameM3U8(filePath: String, oldName: String, newName: String) -> Bool {
        var contents = getM3U8Components(filePath: filePath)
        guard let index = contents.firstIndex(of: "#" + oldName) else { return false }
        contents[index] = "#" + newName
        let newContent = contents.joined(separator: "\n")
        guard FileService.updateFile(filePath: filePath, content: newContent) else { return false }
        return FileService.renameFile(filePath: filePath, newName: newName)
    }
    
    //delete
    static func removeMusic(M3U8FilePath: String, musicFilePath: String) -> Bool {
        var contents = getM3U8Components(filePath: M3U8FilePath)
        guard let index = contents.firstIndex(of: musicFilePath) else { return false }
        contents.remove(at: index)
        let newContent = contents.joined(separator: "\n")
        return FileService.updateFile(filePath: M3U8FilePath, content: newContent)
    }
    
    static func cleanUpM3U8(filePath: String) -> Bool {
        guard let fileName = filePath.components(separatedBy: "\n").last else { return false }
        let content = "#EXTM3U\n" + "#\(fileName)"
        return FileService.updateFile(filePath: filePath, content: content)
    }
    
    static func deleteM3U8(filePath: String) -> Bool {
        FileService.fileDelete(filePath: filePath)
    }
}
