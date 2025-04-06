//
//  M3U8Service.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/04.
//

import Foundation

class M3U8Service {
    //create
    static func createM3U8(folderName: String, fileName: String, musicPaths: [String]) -> Bool {
        let fileName = "\(fileName).m3u8"
        let content = "#EXTM3U\n" + "#\(fileName)\n" + musicPaths.joined(separator: "\n")
        guard let fileURL = FileService.documentDirectory?.appendingPathComponent("Playlist").appendingPathComponent(fileName) else { return false }
        if FileService.createFile(fileURL: fileURL, content: content) {
            return true
        }
        return false
    }
    
    //check
    static func isExistM3U8(filePath: String) -> Bool {
        FileService.isExistFile(filePath: filePath)
    }
    
    //get
    static func getM3U8Content(filePath: String) -> [String] {
        guard let fileURL = FileService.documentDirectory?.appendingPathComponent(filePath) else { return [] }
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let filePaths = content.components(separatedBy: "\n")
            return filePaths
        } catch {
            print(error)
        }
        return []
    }
    
    //update
    static func addMusic(M3U8FilePath: String, musicFilePath: String) -> Bool {
        guard let M3U8FileURL = FileService.documentDirectory?.appendingPathComponent(M3U8FilePath) else { return false }
        do {
            let content = try String(contentsOf: M3U8FileURL, encoding: .utf8)
            var musicFilePaths = content.components(separatedBy: "\n")
            musicFilePaths.append(musicFilePath)
            let newContent = musicFilePaths.joined(separator: "\n")
            if FileService.createFile(fileURL: M3U8FileURL, content: newContent) {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    //delete
    static func removeMusic(M3U8FilePath: String, musicFilePath: String) -> Bool {
        guard let M3U8FileURL = FileService.documentDirectory?.appendingPathComponent(M3U8FilePath) else { return false }
        do {
            let content = try String(contentsOf: M3U8FileURL, encoding: .utf8)
            var musicFilePaths = content.components(separatedBy: "\n")
            if let index = musicFilePaths.firstIndex(of: musicFilePath) {
                musicFilePaths.remove(at: index)
            }
            let newContent = musicFilePaths.joined(separator: "\n")
            if FileService.createFile(fileURL: M3U8FileURL, content: newContent) {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    
    static func deleteM3U8(filePath: String) -> Bool {
        if FileService.fileDelete(filePath: filePath) {
            return true
        }
        return false
    }
}
