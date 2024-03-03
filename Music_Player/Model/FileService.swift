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
            let music = await fileMetadata(musicName: musicName, filePath: filePath)
            musicArray.append(music)
        }
        return musicArray
    }
    
    func fileMetadata(musicName: String, filePath: String) async -> Music {
        let fileURL = URL(fileURLWithPath: filePath)
        let asset = AVAsset(url: fileURL)
        guard let metadata = try? await asset.load(.commonMetadata) else { return Music(musicName: musicName, artistName: "不明", albumName: "不明", editedDate: Date(), fileSize: "0MB", filePath: filePath)}
        let artistName = try? await metadata.first(where: {$0.commonKey == .commonKeyArtist})?.load(.stringValue)
        let albumName = try? await metadata.first(where: {$0.commonKey == .commonKeyAlbumName})?.load(.stringValue)
        var editedDate: Date?
        var fileSize: String?
        let filePath = fileURL.path(percentEncoded: false)
        do {
            let attributes:[FileAttributeKey:Any] = try fileManager.attributesOfItem(atPath: filePath)
            editedDate = attributes[FileAttributeKey.modificationDate] as? Date
            if let bytes = attributes[.size] as? Int64 {
                let bcf = ByteCountFormatter()
                bcf.allowedUnits = [.useAll]
                bcf.countStyle = .file
                fileSize = bcf.string(fromByteCount: bytes)
            }
        } catch {
            print(error)
        }
        let music = Music(musicName: musicName, artistName: artistName!, albumName: albumName!, editedDate: editedDate!, fileSize: fileSize!, filePath: filePath)
        return music
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
