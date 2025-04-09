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
    
    static func getM3U8FilePaths(folderPath: String) -> [String] {
        FileService.getPlaylistFilePaths()
    }
    
    static func getM3U8Name(filePath: String) -> String {
        let components = getM3U8Components(filePath: filePath)
        return String(components[1].dropFirst())
    }
    
    //update
    static func addMusic(M3U8FilePath: String, musicFilePath: String) -> Bool {
        var components = getM3U8Components(filePath: M3U8FilePath)
        components.append(musicFilePath)
        let newContent = components.joined(separator: "\n")
        return FileService.updateFile(filePath: M3U8FilePath, content: newContent)
    }
    
    static func addMusics(M3U8FilePath: String, musicFilePaths: [String]) -> Bool {
        var components = getM3U8Components(filePath: M3U8FilePath)
        components.append(contentsOf: musicFilePaths)
        let newContent = components.joined(separator: "\n")
        return FileService.updateFile(filePath: M3U8FilePath, content: newContent)
    }
    
    static func insertMusic(M3U8FilePath: String, musicFilePath: String, index: Int) -> Bool {
        var components = getM3U8Components(filePath: M3U8FilePath)
        components.insert(musicFilePath, at: index)
        let newContent = components.joined(separator: "\n")
        return FileService.updateFile(filePath: M3U8FilePath, content: newContent)
    }
    
    static func insertMusics(M3U8FilePath: String, musicFilePaths: [String], index: Int) -> Bool {
        var components = getM3U8Components(filePath: M3U8FilePath)
        components.insert(contentsOf: musicFilePaths, at: index)
        let newContent = components.joined(separator: "\n")
        return FileService.updateFile(filePath: M3U8FilePath, content: newContent)
    }
    
    static func updateM3U8(filePath: String, contents: [String]) -> Bool {
        let fileName = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
        var newContent: String = "#EXTM3U\n" + "#\(fileName)"
        if !contents.isEmpty {
            newContent = "#EXTM3U\n" + "#\(fileName)\n" + contents.joined(separator: "\n")
        }
        return FileService.updateFile(filePath: filePath, content: newContent)
    }
    
    static func renameM3U8(filePath: String, newName: String) -> Bool {
        var contents = getM3U8Components(filePath: filePath)
        contents[1] = "#" + newName
        let newContent = contents.joined(separator: "\n")
        var filePathComponents = filePath.components(separatedBy: "\n")
        filePathComponents[filePathComponents.count - 1] = "\(newName).m3u8"
        let newFilePath = filePathComponents.joined(separator: "\n")
        guard FileService.updateFile(filePath: filePath, content: newContent) else { return false }
        return FileService.renameFile(filePath: filePath, newFilePath: newFilePath)
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
        let fileName = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
        let content = "#EXTM3U\n" + "#\(fileName)"
        return FileService.updateFile(filePath: filePath, content: content)
    }
    
    static func deleteM3U8(filePath: String) -> Bool {
        FileService.fileDelete(filePath: filePath)
    }
}
