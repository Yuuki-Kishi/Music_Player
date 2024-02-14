//
//  FileManager.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/05.
//

import Foundation
import AVKit
import AVFoundation

final class FileService {
    public static let shared = FileService()
    var musicArray = [(musicName: String, artistName: String, albumName: String, editedDate: Date, filePath: String)]()
    var artistArray = [(artistName: String, musicCount: Int)]()
    var albumArray = [(albumName: String, musicCount: Int)]()
    var playListArray = [(playListName: String, musicCount: Int, madeDate: Date)]()
    var folderArray = [(folderName: String, folderPath: String, musicCount: Int)]()
    var listMusicArray = [(musicName: String, artistName: String, albumName: String, editedDate: Date, filePath: String)]()
    
    var seekPosition = 0.5
    var sortObjectArray = 0
    var sortModeArray = 0
    var isPlay = false
    var showSheet = false
    let fileManager = FileManager.default
    
    private init() {}
    
    func directoryCheck() async {
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
    
    func getFiles() async {
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
    
    func containFolder(fileURLs: Array<URL>) {
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
    
    func collectFile(fileURLs: Array<URL>) async {
        musicArray = []
        for fileURL in fileURLs {
            var filePieces = fileURL.pathComponents
            let musicName = String(filePieces.last!.dropLast(4))
            filePieces.removeFirst()
            let filePath = "/" + filePieces.joined(separator: "/")
            let metadata = await fileMetadata(fileURL: fileURL)
            let artistName = metadata[0].artistName
            let albumName = metadata[0].albumName
            let editedDate = metadata[0].editedDate
            musicArray.append((musicName: musicName, artistName: artistName, albumName: albumName, editedDate: editedDate, filePath: filePath))
        }
    }
    
    func fileMetadata(fileURL: URL) async -> [(artistName: String, albumName: String, editedDate: Date)] {
        let asset = AVAsset(url: fileURL)
        guard let metadata = try? await asset.load(.commonMetadata) else { return [(artistName: "不明", albumName: "不明", editedDate: Date())] }
        let artistName = try? await metadata.first(where: {$0.commonKey == .commonKeyArtist})?.load(.stringValue)
        let albumName = try? await metadata.first(where: {$0.commonKey == .commonKeyAlbumName})?.load(.stringValue)
        var editedDate = try? await metadata.first(where: {$0.commonKey == .commonKeyCreationDate})?.load(.dateValue)
        let filePath = fileURL.path(percentEncoded: false)
        do {
            let attributes:[FileAttributeKey:Any] = try fileManager.attributesOfItem(atPath: filePath)
            editedDate = attributes[FileAttributeKey.modificationDate] as? Date
        } catch {
            print(error)
        }
        containArtistNameAndAlbumName(artistName: artistName!, albumName: albumName!)
        return [(artistName: artistName!, albumName: albumName!, editedDate: editedDate!)]
    }
    
    func containArtistNameAndAlbumName(artistName: String, albumName: String) {
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
    
    func collectMusic(viewName: String, itemName: String) {
        listMusicArray = []
        switch viewName {
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
    
    func sort() {
        switch sortObjectArray {
        case 0:
            switch sortModeArray {
            case 0:
                musicArray.sort {$0.musicName < $1.musicName}
            case 1:
                musicArray.sort {$0.musicName > $1.musicName}
            case 2:
                musicArray.sort {$0.editedDate < $1.editedDate}
            case 3:
                musicArray.sort {$0.editedDate > $1.editedDate}
            default:
                break
            }
        case 1:
            switch sortModeArray {
            case 0:
                artistArray.sort {$0.artistName < $1.artistName}
            case 1:
                artistArray.sort {$0.artistName > $1.artistName}
            default:
                break
            }
        case 2:
            switch sortModeArray {
            case 0:
                albumArray.sort {$0.albumName < $1.albumName}
            case 1:
                albumArray.sort {$0.albumName > $1.albumName}
            default:
                break
            }
        case 3:
            switch sortModeArray {
            case 0:
                playListArray.sort {$0.playListName < $1.playListName}
            case 1:
                playListArray.sort {$0.playListName > $1.playListName}
            case 2:
                playListArray.sort {$0.madeDate < $1.madeDate}
            case 3:
                playListArray.sort {$0.madeDate > $1.madeDate}
            default:
                break
            }
        case 4:
            switch sortModeArray {
            case 0:
                listMusicArray.sort {$0.musicName < $1.musicName}
            case 1:
                listMusicArray.sort {$0.musicName > $1.musicName}
            case 2:
                listMusicArray.sort {$0.editedDate < $1.editedDate}
            case 3:
                listMusicArray.sort {$0.editedDate > $1.editedDate}
            default:
                break
            }
        default:
            break
        }
    }
}
