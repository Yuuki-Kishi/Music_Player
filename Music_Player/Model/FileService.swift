//
//  FileManager.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/05.
//

import Foundation
import AVKit
import AVFoundation

struct FileService {
    var musicArray = [(musicName: String, artistName: String, albumName: String, editedDate: Date, filePath: String)]()
    var artistArray = [(artistName: String, musicCount: Int)]()
    var albumArray = [(albumName: String, musicCount: Int)]()
    var playListArray = [(playListName: String, musicCount: Int, madeDate: Date)]()
    var folderArray = [(folderName: String, folderPath: String, musicCount: Int)]()
    var listMusicArray = [(musicName: String, artistName: String, albumName: String, editedDate: Date, filePath: String)]()
    
    var seekPosition = 0.5
    enum sortObject {
        case musicArray, artistArray, albumArray, playListArray, listMusicArray
    }
    enum sortMode {
        case nameAsc, nameDesc, dateAsc, dateDesc
    }
    var sortObjectArray = sortObject.musicArray
    var sortModeArray = sortMode.nameAsc
    var isPlay = false
    var showSheet = false
    let fileManager = FileManager.default
    
    mutating func directoryCheck() async {
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
        await getFiles()
    }
    
//    mutating func collcectFolder() {
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL!, includingPropertiesForKeys: nil, options: [])
//            for fileURL in fileURLs {
//                print(fileURL.path)
//            }
//        } catch {
//            print("エラー: \(error)")
//        }
//    }
    
    mutating func getFiles() async {
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
        containFolder(fileURLs: fileURLs)
        await collectFile(fileURLs: fileURLs)
    }
    
    mutating func containFolder(fileURLs: Array<URL>) {
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
                folderArray.append((folderName: folderName, folderPath: folderPath, musicCount: 1))
            }
        }
    }
    
    mutating func collectFile(fileURLs: Array<URL>) async {
        musicArray = []
        for fileURL in fileURLs {
            var filePieces = fileURL.pathComponents
            filePieces.removeFirst()
            let filePath = "/" + filePieces.joined(separator: "/")
            let metadata = await fileMetadata(fileURL: fileURL)
        }
    }
    
    mutating func fileMetadata(fileURL: URL) async -> [(artistName: String, albumName: String, editedDate: Date)] {
        let asset = AVAsset(url: fileURL)
        guard let metadata = try? await asset.load(.metadata) else { return [(artistName: "不明", albumName: "不明", editedDate: Date())] }
        let artistName = try? await metadata.first(where: {$0.commonKey == .commonKeyArtist})?.load(.stringValue)
        let albumName = try? await metadata.first(where: {$0.commonKey == .commonKeyAlbumName})?.load(.stringValue)
        let editedDate = try? await metadata.first(where: {$0.commonKey == .commonKeyLastModifiedDate})?.load(.dateValue)
        containArtistNameAndAlbumName(artistName: artistName!, albumName: albumName!)
        return [(artistName: artistName!, albumName: albumName!, editedDate: editedDate!)]
    }
    
    mutating func containArtistNameAndAlbumName(artistName: String, albumName: String) {
        let artistIscontain = artistArray.contains(where: {$0.artistName == artistName})
        if artistIscontain {
            let index = artistArray.firstIndex(where: {$0.artistName == artistName})!
            artistArray[index].musicCount += 1
        } else {
            artistArray.append((artistName: artistName, musicCount: 1))
        }
        let albumIscontain = albumArray.contains(where: {$0.albumName == albumName})
        if albumIscontain {
            let index = albumArray.firstIndex(where: {$0.albumName == albumName})!
            albumArray[index].musicCount += 1
        } else {
            albumArray.append((albumName: albumName, musicCount: 1))
        }
    }
    
    mutating func collectMusic(item: String, itemName: String) {
        listMusicArray = []
        switch item {
        case "artist":
            for music in musicArray {
                let musicName = music.musicName
                let artistName = music.artistName
                let albumName = music.albumName
                let editedDate = music.editedDate
                let filePath = music.filePath
                if artistName == itemName {
                    listMusicArray.append((musicName: musicName, artistName: artistName, albumName: albumName, editedDate: editedDate, filePath: filePath))
                }
            }
        case "album":
            for music in musicArray {
                let musicName = music.musicName
                let artistName = music.artistName
                let albumName = music.albumName
                let editedDate = music.editedDate
                let filePath = music.filePath
                if albumName == itemName {
                    listMusicArray.append((musicName: musicName, artistName: artistName, albumName: albumName, editedDate: editedDate, filePath: filePath))
                }
            }
        case "playList":
            for music in musicArray {
                let musicName = music.musicName
                let artistName = music.artistName
                let albumName = music.albumName
                let editedDate = music.editedDate
                let filePath = music.filePath
//                if playListName == itemName {
//                    listMusicArray.append((musicName: musicName, artistName: artistName, albumName: albumName, editedDate: editedDate, filePath: filePath))
//                }
            }
        default:
            break
        }
    }
    
    mutating func sort() {
        switch sortObjectArray {
        case .musicArray:
            switch sortModeArray {
            case .nameAsc:
                musicArray.sort {$0.musicName < $1.musicName}
            case .nameDesc:
                musicArray.sort {$0.musicName > $1.musicName}
            case .dateAsc:
                musicArray.sort {$0.editedDate < $1.editedDate}
            case .dateDesc:
                musicArray.sort {$0.editedDate > $1.editedDate}
            }
        case .artistArray:
            switch sortModeArray {
            case .nameAsc:
                artistArray.sort {$0.artistName < $1.artistName}
            case .nameDesc:
                artistArray.sort {$0.artistName > $1.artistName}
            default:
                break
            }
        case .albumArray:
            switch sortModeArray {
            case .nameAsc:
                albumArray.sort {$0.albumName < $1.albumName}
            case .nameDesc:
                albumArray.sort {$0.albumName > $1.albumName}
            default:
                break
            }
        case .playListArray:
            switch sortModeArray {
            case .nameAsc:
                playListArray.sort {$0.playListName < $1.playListName}
            case .nameDesc:
                playListArray.sort {$0.playListName > $1.playListName}
            case .dateAsc:
                playListArray.sort {$0.madeDate < $1.madeDate}
            case .dateDesc:
                playListArray.sort {$0.madeDate > $1.madeDate}
            }
        case .listMusicArray:
            switch sortModeArray {
            case .nameAsc:
                listMusicArray.sort {$0.musicName < $1.musicName}
            case .nameDesc:
                listMusicArray.sort {$0.musicName > $1.musicName}
            case .dateAsc:
                listMusicArray.sort {$0.editedDate < $1.editedDate}
            case .dateDesc:
                listMusicArray.sort {$0.editedDate > $1.editedDate}
            }
        }
    }
}
