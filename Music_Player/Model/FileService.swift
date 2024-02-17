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
        guard let metadata = try? await asset.load(.commonMetadata) else { return Music(musicName: musicName, artistName: "不明", albumName: "不明", editedDate: Date(), filePath: filePath)}
        let artistName = try? await metadata.first(where: {$0.commonKey == .commonKeyArtist})?.load(.stringValue)
        let albumName = try? await metadata.first(where: {$0.commonKey == .commonKeyAlbumName})?.load(.stringValue)
        var editedDate: Date?
        let filePath = fileURL.path(percentEncoded: false)
        do {
            let attributes:[FileAttributeKey:Any] = try fileManager.attributesOfItem(atPath: filePath)
            editedDate = attributes[FileAttributeKey.modificationDate] as? Date
        } catch {
            print(error)
        }
        let music = Music(musicName: musicName, artistName: artistName!, albumName: albumName!, editedDate: editedDate!, filePath: filePath)
        return music
    }
    
//    func sort() {
//        switch sortObjectArray {
//        case 0:
//            switch sortModeArray {
//            case 0:
//                musicArray.sort {$0.musicName < $1.musicName}
//            case 1:
//                musicArray.sort {$0.musicName > $1.musicName}
//            case 2:
//                musicArray.sort {$0.editedDate < $1.editedDate}
//            case 3:
//                musicArray.sort {$0.editedDate > $1.editedDate}
//            default:
//                break
//            }
//        case 1:
//            switch sortModeArray {
//            case 0:
//                artistArray.sort {$0.artistName < $1.artistName}
//            case 1:
//                artistArray.sort {$0.artistName > $1.artistName}
//            default:
//                break
//            }
//        case 2:
//            switch sortModeArray {
//            case 0:
//                albumArray.sort {$0.albumName < $1.albumName}
//            case 1:
//                albumArray.sort {$0.albumName > $1.albumName}
//            default:
//                break
//            }
//        case 3:
//            switch sortModeArray {
//            case 0:
//                playListArray.sort {$0.playListName < $1.playListName}
//            case 1:
//                playListArray.sort {$0.playListName > $1.playListName}
//            case 2:
//                playListArray.sort {$0.madeDate < $1.madeDate}
//            case 3:
//                playListArray.sort {$0.madeDate > $1.madeDate}
//            default:
//                break
//            }
//        case 4:
//            switch sortModeArray {
//            case 0:
//                listMusicArray.sort {$0.musicName < $1.musicName}
//            case 1:
//                listMusicArray.sort {$0.musicName > $1.musicName}
//            case 2:
//                listMusicArray.sort {$0.editedDate < $1.editedDate}
//            case 3:
//                listMusicArray.sort {$0.editedDate > $1.editedDate}
//            default:
//                break
//            }
//        default:
//            break
//        }
//    }
}
