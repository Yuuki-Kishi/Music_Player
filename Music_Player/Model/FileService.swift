//
//  FileManager.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/05.
//

import Foundation
import AVKit
import AVFoundation
import SwiftData

final class FileService {
    let fileManager = FileManager.default
        
    func directoryCheck() -> Bool {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = documentsPath + "/explain.txt"
        let isDirectory = fileManager.fileExists(atPath: filePath)
        return isDirectory
    }
    
    func makeDirectory() {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentDirectory!.appendingPathComponent("explain.txt")
        let content = "ここに書いた説明を読めるようにするために、このファイルを「このiPhone内」のフォルダの中に保存できるようにしたい。"
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    func getFiles() -> Array<URL> {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let files = fileManager.enumerator(at: documentsURL, includingPropertiesForKeys: [])
        var fileURLs = [URL]()
        while let url = files?.nextObject() as? URL {
            let filePath = url.path(percentEncoded: false)
            if filePath.contains(".Trash") { continue }
            let fileType = filePath.suffix(3)
            if fileType != "mp3" && fileType != "m4a" && fileType != "wav" { continue }
            fileURLs.append(url)
        }
        return fileURLs
    }
    
    func containFolder(fileURLs: Array<URL>) -> Array<Folder>{
        var folderArray = [Folder]()
        for fileURL in fileURLs {
            var filePieces = fileURL.pathComponents
            let folderName = filePieces[filePieces.count - 2]
            filePieces.removeFirst()
            filePieces.removeLast()
            let folderPath = "/" + filePieces.joined(separator: "/")
            let contain = folderArray.contains(where: {$0.folderPath == folderPath})
            if contain {
                let index = folderArray.firstIndex(where: {$0.folderPath == folderPath})!
                folderArray[index].musicCount += 1
            } else {
                let folder = Folder(folderName: folderName, musicCount: 1, folderPath: folderPath)
                folderArray.append(folder)
            }
        }
        return folderArray
    }
    
    func collectFile(fileURLs: Array<URL>) async -> Array<Music> {
        var musicArray = [Music]()
        for fileURL in fileURLs {
            var filePieces = fileURL.pathComponents
            let musicName = String(filePieces.last!.dropLast(4))
            filePieces.removeFirst()
            let filePath = "/" + filePieces.joined(separator: "/")
            let music = await fileMetadata(fileName: musicName, filePath: filePath)
            musicArray.append(music)
        }
        return musicArray
    }
    
    func fileMetadata(fileName: String, filePath: String) async -> Music {
        let fileURL = URL(fileURLWithPath: filePath)
        let asset = AVAsset(url: fileURL)
        guard let metadata = try? await asset.load(.commonMetadata) else { return Music() }
        let musicName = try? await metadata.first(where: {$0.commonKey == .commonKeyTitle})?.load(.stringValue)
        let artistName = try? await metadata.first(where: {$0.commonKey == .commonKeyArtist})?.load(.stringValue)
        let albumName = try? await metadata.first(where: {$0.commonKey == .commonKeyAlbumName})?.load(.stringValue)
        let fullFilePath = fileURL.path(percentEncoded: false)
        let filePath = getEditedFilePath(fileURL: fileURL)
        let editedDate = getEditedDate(filePath: fullFilePath)
        let fileSize = getFileSize(filePath: fullFilePath)
        let musicLength = getMusicLength(fileURL: fileURL)
        let music = Music(musicName: musicName, artistName: artistName, albumName: albumName, editedDate: editedDate, fileSize: fileSize, musicLength: musicLength, filePath: filePath)
        return music
    }
    
    func getEditedFilePath(fileURL: URL) -> String {
        var filePathPieces = fileURL.pathComponents
        let index = filePathPieces.firstIndex(where: {$0 == "Documents"})!
        for i in 0 ... index {
            filePathPieces.removeFirst()
        }
        return filePathPieces.joined(separator: "/")
    }
    
    func getEditedDate(filePath: String) -> Date? {
        var editedDate: Date?
        do {
            let attributes:[FileAttributeKey:Any] = try fileManager.attributesOfItem(atPath: filePath)
            editedDate = attributes[FileAttributeKey.modificationDate] as? Date
        } catch {
            print(error)
        }
        return editedDate
    }
    
    func getFileSize(filePath: String) -> String? {
        var fileSize: String?
        do {
            let attributes:[FileAttributeKey:Any] = try fileManager.attributesOfItem(atPath: filePath)
            if let bytes = attributes[.size] as? Int64 {
                let bcf = ByteCountFormatter()
                bcf.allowedUnits = [.useAll]
                bcf.countStyle = .file
                fileSize = bcf.string(fromByteCount: bytes)
            }
        } catch {
            print(error)
        }
        return fileSize
    }
    
    func getMusicLength(fileURL: URL) -> TimeInterval? {
        do {
            let audioPlayer: AVAudioPlayer = try! AVAudioPlayer(contentsOf: fileURL)
            let duration = audioPlayer.duration
            return duration
        } catch {
            return nil
        }
    }
    
    func fileDelete(filePath: String?) {
        do {
            let url = URL(fileURLWithPath: filePath!)
            try fileManager.trashItem(at: url, resultingItemURL: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
