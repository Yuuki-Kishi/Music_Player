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
        FileService.isExist(path: filePath)
    }
    
    //get
    static func getM3U8Components(filePath: String) -> [String] {
        guard let content = FileService.getFileContentString(filePath: filePath) else { return [] }
        return Array(content.components(separatedBy: "\n").dropFirst(2))
    }
    
    static func getM3U8FilePaths(folderPath: String) -> [String] {
        FileService.getFilePaths(folderPath: folderPath).map { folderPath + $0 }
    }
    
    static func getM3U8Name(filePath: String) -> String? {
        guard let content = FileService.getFileContentString(filePath: filePath) else { return nil }
        let components = content.components(separatedBy: "\n")
        return String(components[1].dropFirst())
    }
    
    //update
    static func addMusic(M3U8FilePath: String, musicFilePath: String) -> Bool {
        var components = getM3U8Components(filePath: M3U8FilePath)
        components.append(musicFilePath)
        let fileName = URL(fileURLWithPath: M3U8FilePath).deletingPathExtension().lastPathComponent
        let newContent = "#EXTM3U\n" + "#\(fileName)\n" + components.joined(separator: "\n")
        return FileService.updateFileString(filePath: M3U8FilePath, content: newContent)
    }
    
    static func addMusics(M3U8FilePath: String, musicFilePaths: [String]) -> Bool {
        var components = getM3U8Components(filePath: M3U8FilePath)
        components.append(contentsOf: musicFilePaths)
        let fileName = URL(fileURLWithPath: M3U8FilePath).deletingPathExtension().lastPathComponent
        let newContent = "#EXTM3U\n" + "#\(fileName)\n" + components.joined(separator: "\n")
        return FileService.updateFileString(filePath: M3U8FilePath, content: newContent)
    }
    
    static func insertMusic(M3U8FilePath: String, musicFilePath: String, index: Int) -> Bool {
        var components = getM3U8Components(filePath: M3U8FilePath)
        components.insert(musicFilePath, at: index)
        let fileName = URL(fileURLWithPath: M3U8FilePath).deletingPathExtension().lastPathComponent
        let newContent = "#EXTM3U\n" + "#\(fileName)\n" + components.joined(separator: "\n")
        return FileService.updateFileString(filePath: M3U8FilePath, content: newContent)
    }
    
    static func insertMusics(M3U8FilePath: String, musicFilePaths: [String], index: Int) -> Bool {
        var components = getM3U8Components(filePath: M3U8FilePath)
        components.insert(contentsOf: musicFilePaths, at: index)
        let fileName = URL(fileURLWithPath: M3U8FilePath).deletingPathExtension().lastPathComponent
        let newContent = "#EXTM3U\n" + "#\(fileName)\n" + components.joined(separator: "\n")
        return FileService.updateFileString(filePath: M3U8FilePath, content: newContent)
    }
    
    static func updateM3U8(filePath: String, contents: [String]) -> Bool {
        let fileName = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
        var newContent: String = "#EXTM3U\n" + "#\(fileName)"
        if !contents.isEmpty {
            newContent = "#EXTM3U\n" + "#\(fileName)\n" + contents.joined(separator: "\n")
        }
        return FileService.updateFileString(filePath: filePath, content: newContent)
    }
    
    static func renameM3U8(filePath: String, newFilePath: String) -> Bool {
        let contents = getM3U8Components(filePath: filePath)
        let newFileName = URL(fileURLWithPath: newFilePath).deletingPathExtension().lastPathComponent
        let newContent: String = "#EXTM3U\n" + "#\(newFileName)\n" + contents.joined(separator: "\n")
        guard FileService.updateFileString(filePath: filePath, content: newContent) else { return false }
        return FileService.moveFile(filePath: filePath, newFilePath: newFilePath)
    }
    
    static func moveM3U8(filePath: String, newFilePath: String) -> Bool {
        FileService.moveFile(filePath: filePath, newFilePath: newFilePath)
    }
    
    //delete
    static func removeMusic(M3U8FilePath: String, musicFilePath: String) -> Bool {
        var contents = getM3U8Components(filePath: M3U8FilePath)
        guard let index = contents.firstIndex(of: musicFilePath) else { return false }
        contents.remove(at: index)
        let fileName = URL(fileURLWithPath: M3U8FilePath).deletingPathExtension().lastPathComponent
        let newContent: String = "#EXTM3U\n" + "#\(fileName)\n" + contents.joined(separator: "\n")
        return FileService.updateFileString(filePath: M3U8FilePath, content: newContent)
    }
    
    static func removeMusics(M3U8FilePath: String, musicFilePaths: [String]) -> Bool {
        var contents = getM3U8Components(filePath: M3U8FilePath)
        for musicFilePath in musicFilePaths {
            guard let index = contents.firstIndex(of: musicFilePath) else { continue }
            contents.remove(at: index)
        }
        let fileName = URL(fileURLWithPath: M3U8FilePath).deletingPathExtension().lastPathComponent
        let newContent: String = "#EXTM3U\n" + "#\(fileName)\n" + contents.joined(separator: "\n")
        return FileService.updateFileString(filePath: M3U8FilePath, content: newContent)
    }
    
    static func cleanUpM3U8(filePath: String) -> Bool {
        let fileName = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
        let content = "#EXTM3U\n" + "#\(fileName)"
        return FileService.updateFileString(filePath: filePath, content: content)
    }
    
    static func deleteM3U8(filePath: String) -> Bool {
        FileService.fileDelete(filePath: filePath)
    }
}
