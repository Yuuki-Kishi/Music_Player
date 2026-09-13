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
    static let fileSizeFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .file
        return formatter
    }()
    
    //create
    static func createFile(filePath: String, content: String) -> Bool {
        guard let fileURL = documentDirectory?.appending(path:filePath) else { return false }
        guard let data = content.data(using: .utf8) else { return false }
        return fileManager.createFile(atPath: fileURL.planePath, contents: data)
    }
    
    static func createDirectory(folderPath: String) {
        guard let folderURL = documentDirectory?.appending(path:folderPath) else { return }
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //check
    static func isExist(path: String) -> Bool {
        guard let url = documentDirectory?.appending(path: path) else { return false }
        return fileManager.fileExists(atPath: url.planePath)
    }
    
    //get
    static func getFilePaths(folderPath: String) -> [String] {
        guard let folderURL = documentDirectory?.appending(path:folderPath) else { return [] }
        var filePaths: [String] = []
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                guard !fileURL.planePath.contains("/.Trash/") else { continue }
                let path = fileURL.planePath.replacingOccurrences(of: folderURL.planePath, with: "")
                let filePath = path.replacingOccurrences(of: "/private", with: "")
                filePaths.append(filePath)
            }
        } catch {
            print(error.localizedDescription)
        }
        return filePaths
    }
    
    static func getAllFilePaths() -> [String] {
        guard let directoryURL = documentDirectory else { return [] }
        let fileURLs = fileManager.enumerator(at: directoryURL, includingPropertiesForKeys: [])
        var filePaths: [String] = []
        while let fileURL = fileURLs?.nextObject() as? URL {
            guard fileURL.isMusicFile else { continue }
            guard !fileURL.planePath.contains("/.Trash/") else { continue }
            let path = fileURL.planePath.replacingOccurrences(of: directoryURL.planePath, with: "")
            let filePath = path.replacingOccurrences(of: "/private", with: "")
            filePaths.append(filePath)
        }
        return filePaths
    }
    
    static func getFileContentString(filePath: String) -> String? {
        guard let fileURL = documentDirectory?.appending(path: filePath) else { return nil }
        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    static func getFileMetadata(filePath: String) async -> Music? {
        guard let fileURL = documentDirectory?.appending(path: filePath) else { return nil }
        let asset = AVURLAsset(url: fileURL)
        async let metadataTask = asset.load(.commonMetadata)
        async let durationTask = asset.load(.duration)
        guard let attributes = try? fileManager.attributesOfItem(atPath: fileURL.planePath) else { return nil }
        guard let editedDate = attributes[.modificationDate] as? Date else { return nil }
        guard let fileSize = attributes[.size] as? UInt64 else { return nil }
        guard let metadata = try? await metadataTask else { return nil }
        let musicLength = (try? await CMTimeGetSeconds(durationTask)) ?? 0
        var musicName: String?
        var artistName: String?
        var albumName: String?
        var coverImage: Data?
        for item in metadata {
            switch item.commonKey {
            case .commonKeyTitle:
                musicName = try? await item.load(.stringValue)
            case .commonKeyArtist:
                artistName = try? await item.load(.stringValue)
            case .commonKeyAlbumName:
                albumName = try? await item.load(.stringValue)
            case .commonKeyArtwork:
                coverImage = try? await item.load(.dataValue)
            default:
                break
            }
        }
        return Music(musicName: musicName, artistName: artistName, albumName: albumName, coverImage: coverImage, editedDate: editedDate, fileSize: fileSize, musicLength: musicLength, filePath: filePath)
    }
    
    //update
    static func updateFileString(filePath: String, content: String) -> Bool {
        guard let fileURL = documentDirectory?.appending(path:filePath) else { return false }
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func moveFile(filePath: String, newFilePath: String) -> Bool {
        guard let fileURL = documentDirectory?.appending(path:filePath) else { return false }
        guard let newFileURL = documentDirectory?.appending(path:newFilePath) else { return false }
        do {
            try fileManager.moveItem(at: fileURL, to: newFileURL)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    //delete
    static func fileDelete(filePath: String) -> Bool {
        guard isExist(path: filePath) else { return false }
        guard let fileURL = documentDirectory?.appending(path:filePath) else { return false }
        do {
            try fileManager.trashItem(at: fileURL, resultingItemURL: nil)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
