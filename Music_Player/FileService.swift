//
//  FileManager.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/05.
//

import Foundation
import AVKit

class FileService {
    static let shared = FileService()
    let fileManager = FileManager.default
    var folderArray = [String]()
    
    func fileImport() -> [(music: String, artist: String, album: String, belong: String)] {
        var fileNames = [String]()
        var musicArray = [(music: String, artist: String, album: String, belong: String)]()
        let belongFolder = "Documents"
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentDirectory!.appendingPathComponent("explain.txt")
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = documentsPath + "/explain.txt"
        let content = "ここに書いた説明を読めるようにするために、このファイルを「このiPhone内」のフォルダの中に保存できるようにしたい。"
        if !fileManager.fileExists(atPath: filePath) {
            do {
                try content.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print(error)
            }
        }
        do {
            let data = try fileManager.contentsOfDirectory(atPath: documentsPath)
            fileNames = data
        } catch {
            print(error)
        }
        for fileName in fileNames {
            if fileName == ".Trash" { continue }
            var type = ""
            do {
                let attri = try fileManager.attributesOfItem(atPath: documentsPath + "/\(fileName)")
                type = attri[.type] as! String
            } catch {
                print(error)
            }
            if type == "NSFileTypeDirectory" { folderArray.append(fileName); continue }
            let fileType = fileName.suffix(3)
            if fileType != "mp3" && fileType != "m4a" && fileType != "wav" {
                fileNames.remove(at: fileNames.firstIndex(of: fileName)!)
            } else {
                var music = fileMetadata(fileName: fileName)
                music[0].belong = belongFolder
                musicArray = musicArray + music
                print(music)
            }
        }
        musicArray.sort {$0.music < $1.music}
        return musicArray
    }
    
    func fileMetadata(fileName: String) -> [(music: String, artist: String, album: String, belong: String)] {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentDirectory!.appendingPathComponent(fileName)
        let file = fileName.dropLast(4)
        let asset = AVAsset(url: fileURL)
        let metaData = asset.metadata
        let artist = metaData.first(where: {$0.commonKey == .commonKeyArtist})
        let artistName = artist?.value as? String
        let album = metaData.first(where: {$0.commonKey == .commonKeyAlbumName})
        let albumName = album?.value as? String
        return [(music: String(file), artist: artistName!, album: albumName!, belong: "String")]
    }
}
