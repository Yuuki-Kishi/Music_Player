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
    static func createFile(fileURL: URL, content: String) -> Bool  {
        guard let data = content.data(using: .utf8) else { return false }
        fileManager.createFile(atPath: fileURL.path(), contents: data)
//        do {
//            try content.write(to: fileURL, atomically: true, encoding: .utf8)
//            return true
//        } catch {
//            print(error)
//        }
        return true
    }
    
    static func createDirectory(directoryName: String) {
        guard let directoryURL = documentDirectory?.appendingPathComponent(directoryName) else { return }
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
    }
    
    //check
    static func isExistDirectory(directoryPath: String) -> Bool {
        guard let directoryURL = documentDirectory?.appendingPathComponent(directoryPath) else { return false }
        let isExists = fileManager.fileExists(atPath: directoryURL.path())
        return isExists
    }
    
    static func isExistFile(filePath: String) -> Bool {
        guard let directoryURL = documentDirectory?.appendingPathComponent(filePath) else { return false }
        print(directoryURL)
        let isExists = fileManager.fileExists(atPath: directoryURL.path())
        return isExists
    }
    
    //get
    static func getFileURLs() -> [URL] {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        let files = fileManager.enumerator(at: documentsURL, includingPropertiesForKeys: [])
        var fileURLs: [URL] = []
        while let url = files?.nextObject() as? URL {
            let lowerPathComponent = url.pathExtension.lowercased()
            if lowerPathComponent.contains(".Trash") { continue }
            if lowerPathComponent != "mp3" && lowerPathComponent != "m4a" && lowerPathComponent != "wav" { continue }
            fileURLs.append(url)
        }
        return fileURLs
    }
    
    static func getFolderName(fileURL: URL) -> String {
        let filePathComponents = fileURL.pathComponents
        let folderName = filePathComponents[filePathComponents.count - 2]
        return folderName
    }
    
    static func getFileMetadata(filePath: String) async -> Music {
        var music: Music = Music()
        guard let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return Music() }
        let fileURL = documentDirectoryURL.appendingPathComponent(filePath)
        let asset = AVAsset(url: fileURL)
        guard let metadata = try? await asset.load(.commonMetadata) else { return Music() }
        let musicName = try? await metadata.first(where: {$0.commonKey == .commonKeyTitle})?.load(.stringValue)
        let artistName = try? await metadata.first(where: {$0.commonKey == .commonKeyArtist})?.load(.stringValue)
        let albumName = try? await metadata.first(where: {$0.commonKey == .commonKeyAlbumName})?.load(.stringValue)
        do {
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useAll]
            bcf.countStyle = .file
            let audioPlayer: AVAudioPlayer = try! AVAudioPlayer(contentsOf: fileURL)
            let attributes:[FileAttributeKey:Any] = try fileManager.attributesOfItem(atPath: fileURL.path())
            guard let editedDate = attributes[FileAttributeKey.modificationDate] as? Date else { return Music() }
            guard let bytes = attributes[.size] as? Int64 else { return Music() }
            let fileSize = bcf.string(fromByteCount: bytes)
            let musicLength = audioPlayer.duration
            music = Music(musicName: musicName ?? "不明な曲", artistName: artistName ?? "不明なアーティスト", albumName: albumName ?? "不明なアルバム", editedDate: editedDate, fileSize: fileSize, musicLength: musicLength, filePath: filePath)
        } catch {
            print(error)
        }
        return music
    }
    
    static func fileDelete(filePath: String) -> Bool {
        if isExistFile(filePath: filePath) {
            guard let fileURL = documentDirectory?.appendingPathComponent(filePath) else { return false }
            do {
                try fileManager.trashItem(at: fileURL, resultingItemURL: nil)
                return true
            } catch {
                print(error)
            }
        }
        return false
    }
}
