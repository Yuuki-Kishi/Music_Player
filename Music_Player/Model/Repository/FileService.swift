//
//  FileManager.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/05.
//

import Foundation
import AVFoundation

class FileService {
    static let fileManager = FileManager.default
    static let documentDirectory: URL? = {
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectory
    }()
    
    //create
    static func createFile(filePath: String, content: String) -> Bool {
        guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return false }
        guard let data = content.data(using: .utf8) else { return false }
        return fileManager.createFile(atPath: fileURL.planePath, contents: data)
    }
    
    static func createDirectory(folderPath: String) {
        guard let folderURL = documentDirectory?.appendingPathComponent(folderPath) else { return }
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
    }
    
    //check
    static func isExistFile(filePath: String) -> Bool {
        guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return false }
        return fileManager.fileExists(atPath: fileURL.planePath)
    }
    
    static func isExistDirectory(folderPath: String) -> Bool {
        guard let folderURL = documentDirectory?.appendingPathComponent(folderPath) else { return false }
        return fileManager.fileExists(atPath: folderURL.planePath)
    }
    
    //get
    static func getFilePaths(folderPath: String) -> [String] {
        guard let folderURL = documentDirectory?.appendingPathComponent(folderPath) else { return [] }
        var filePaths: [String] = []
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                if fileURL.planePath.contains("/.Trash/") || fileURL.planePath.contains("/Playlist/") { continue }
                let path = fileURL.planePath.replacingOccurrences(of: folderURL.planePath, with: "")
                let filePath = path.replacingOccurrences(of: "/private", with: "")
                filePaths.append(filePath)
            }
        } catch {
            print(error)
        }
        return filePaths
    }
    
    static func getPlaylistFilePaths() -> [String] {
        guard let folderURL = documentDirectory?.appendingPathComponent("Playlist") else { return [] }
        var filePaths: [String] = []
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil).filter { $0.planePath.contains(".m3u8") }
            for fileURL in fileURLs {
                if fileURL.planePath.contains("/.Trash/") { continue }
                let path = fileURL.planePath.replacingOccurrences(of: folderURL.planePath, with: "")
                let filePath = path.replacingOccurrences(of: "/private", with: "")
                filePaths.append(filePath)
            }
        } catch {
            print(error)
        }
        return filePaths
    }
    
    static func getAllFilePaths() -> [String] {
        guard let directoryURL = documentDirectory else { return [] }
        let fileURLs = fileManager.enumerator(at: directoryURL, includingPropertiesForKeys: [])
        var filePaths: [String] = []
        while let fileURL = fileURLs?.nextObject() as? URL {
            if !fileURL.isMusicFile { continue }
            let resourceValues = try? fileURL.resourceValues(forKeys: [.isDirectoryKey])
            if resourceValues?.isDirectory == true { continue }
            let path = fileURL.planePath.replacingOccurrences(of: directoryURL.planePath, with: "")
            let filePath = path.replacingOccurrences(of: "/private", with: "")
            filePaths.append(filePath)
        }
        return filePaths
    }
    
    static func getFolderPaths() -> [String] {
        guard let directoryURL = documentDirectory else { return [] }
        let fileURLs = fileManager.enumerator(at: directoryURL, includingPropertiesForKeys: [])
        var folderPaths: [String] = []
        while let fileURL = fileURLs?.nextObject() as? URL {
            if !fileURL.isMusicFile { continue }
            let resourceValues = try? fileURL.resourceValues(forKeys: [.isDirectoryKey])
            if resourceValues?.isDirectory == true { continue }
            let path = fileURL.deletingLastPathComponent().planePath.replacingOccurrences(of: "/private", with: "")
            let folderPath = path.replacingOccurrences(of: directoryURL.planePath, with: "")
            folderPaths.append(folderPath)
        }
        return folderPaths
    }
    
    static func getFileContent(filePath: String) -> String? {
        guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return nil }
        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print(error)
        }
        return nil
    }
    
    static func getFileMetadata(filePath: String) async -> Music {
        var music: Music = Music()
        guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return Music() }
        let asset = AVURLAsset(url: fileURL)
        guard let metadata = try? await asset.load(.commonMetadata) else { return Music() }
        let musicName = try? await metadata.first(where: {$0.commonKey == .commonKeyTitle})?.load(.stringValue)
        let artistName = try? await metadata.first(where: {$0.commonKey == .commonKeyArtist})?.load(.stringValue)
        let albumName = try? await metadata.first(where: {$0.commonKey == .commonKeyAlbumName})?.load(.stringValue)
        do {
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useAll]
            bcf.countStyle = .file
            let attributes: [FileAttributeKey: Any] = try fileManager.attributesOfItem(atPath: fileURL.planePath)
            guard let editedDate = attributes[FileAttributeKey.modificationDate] as? Date else { return Music() }
            guard let bytes = attributes[.size] as? Int64 else { return Music() }
            let fileSize = bcf.string(fromByteCount: bytes)
            let musicLength = try await CMTimeGetSeconds(asset.load(.duration))
            music = Music(musicName: musicName ?? "不明な曲", artistName: artistName ?? "不明なアーティスト", albumName: albumName ?? "不明なアルバム", editedDate: editedDate, fileSize: fileSize, musicLength: musicLength, filePath: filePath)
        } catch {
            print(error)
        }
        return music
    }
    
    //update
    static func updateFile(filePath: String, content: String) -> Bool {
        guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return false }
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    static func renameFile(filePath: String, newFilePath: String) -> Bool {
        guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return false }
        guard let newFileURL = documentDirectory?.appendingPathComponent(newFilePath) else { return false }
        do {
            try fileManager.moveItem(at: fileURL, to: newFileURL)
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    //delete
    static func fileDelete(filePath: String) -> Bool {
        guard isExistFile(filePath: filePath) else { return false }
        guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return false }
        do {
            try fileManager.trashItem(at: fileURL, resultingItemURL: nil)
            return true
        } catch {
            print(error)
        }
        return false
    }
}
