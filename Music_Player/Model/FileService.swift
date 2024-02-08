//
//  FileManager.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/05.
//

import Foundation
import AVKit

struct FileService {
    var musicArray = [(musicName: String, artistName: String, albumName: String, belongDirectory: String)]()
    var artistArray = [(artistName: String, musicCount: Int)]()
    var albumArray = [(albumName: String, musicCount: Int)]()
    var playListArray = [(playListName: String, musicCount: Int)]()
    var folderArray = [(folderName: String, folderPath: String)]()
    var listMusicArray = [(musicName: String, artistName: String, albumName: String, belongDirectory: String)]()
    
    var seekPosition = 0.5
    var playMode = 0
    var isPlay = false
    var showSheet = false
    let fileManager = FileManager.default
    
    mutating func directoryCheck() {
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
        fileImport()
    }
    
    mutating func fileImport() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        folderArray.append((folderName: "Documents", folderPath: documentsPath))
        for folderData in folderArray {
            let folderName = folderData.folderName
            let folderPath = folderData.folderPath
            collectFile(folderName: folderName, folderPath: folderPath)
        }
    }
    
    mutating func collectFile(folderName: String, folderPath: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        var fileNames = [String]()
        do {
            fileNames = try fileManager.contentsOfDirectory(atPath: folderPath)
        } catch {
            print(error)
        }
        for fileName in fileNames {
            if fileName == ".Trash" { continue }
            var type = ""
            do {
                let attributes = try fileManager.attributesOfItem(atPath: documentsPath + "/\(fileName)")
                type = attributes[.type] as! String
            } catch {
                print(error)
            }
            if type == "NSFileTypeDirectory" { folderArray.append((folderName: fileName, folderPath: folderPath)); continue }
            let fileType = fileName.suffix(3)
            if fileType != "mp3" && fileType != "m4a" && fileType != "wav" {
                fileNames.remove(at: fileNames.firstIndex(of: fileName)!)
            } else {
                var music = fileMetadata(fileName: fileName)
                music[0].belongDirectory = folderName
                musicArray = musicArray + music
            }
        }
        musicArray.sort {$0.musicName < $1.musicName}
        collectArtistName()
        collectAlbumName()
    }
    
    mutating func fileMetadata(fileName: String) -> [(musicName: String, artistName: String, albumName: String, belongDirectory: String)] {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentDirectory!.appendingPathComponent(fileName)
        let file = fileName.dropLast(4)
        let asset = AVAsset(url: fileURL)
        let metaData = asset.metadata
        let artist = metaData.first(where: {$0.commonKey == .commonKeyArtist})
        let artistName = artist?.value as? String
        let album = metaData.first(where: {$0.commonKey == .commonKeyAlbumName})
        let albumName = album?.value as? String
        return [(musicName: String(file), artistName: artistName!, albumName: albumName!, belongDirectory: "String")]
    }
    
    mutating func collectArtistName() {
        for music in musicArray {
            let artistName = music.artistName
            let contain = artistArray.contains(where: {$0.artistName == artistName})
            if contain {
                let index = artistArray.firstIndex(where: {$0.artistName == artistName})!
                artistArray[index].musicCount += 1
            } else {
                artistArray.append((artistName: artistName, musicCount: 1))
            }
        }
        artistArray.sort {$0.artistName < $1.artistName}
    }
    
    mutating func collectAlbumName() {
        for music in musicArray {
            let albumName = music.albumName
            let contain = albumArray.contains(where: {$0.albumName == albumName})
            if contain {
                let index = albumArray.firstIndex(where: {$0.albumName == albumName})!
                albumArray[index].musicCount += 1
            } else {
                albumArray.append((albumName: albumName, musicCount: 1))
            }
        }
        albumArray.sort {$0.albumName < $1.albumName}
    }
}
