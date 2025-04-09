//
//  WPMDService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/20.
//

import Foundation

class WillPlayRepository {
    static let filePath: String = "Playlist/System/WillPlay.m3u8"
    
    //create
    static func createWillPlayM3U8() -> Bool {
        let content = "#EXTM3U\n" + "#WillPlay"
        return FileService.createFile(filePath: filePath, content: content)
    }
    
    //check
    static func isExistWillPlayM3U8() -> Bool {
        M3U8Service.isExistM3U8(filePath: filePath)
    }
    
    //get
    static func getWillPlay() async -> [Music] {
        var musics: [Music] = []
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(2)
        for filePath in filePaths {
            if !FileService.isExistFile(filePath: filePath) {
                guard M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath) else { continue }
                print("removeSucceed")
                continue
            }
            let music = await FileService.getFileMetadata(filePath: filePath)
            musics.append(music)
        }
        return musics
    }
    
    static func nextMusic() async -> Music? {
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(2)
        if let nextFilePath = filePaths.first {
            guard FileService.isExistFile(filePath: nextFilePath) else { return nil }
            return await FileService.getFileMetadata(filePath: nextFilePath)
        }
        return nil
    }
    
    //update
    static func addWillPlay(newMusicFilePaths: [String]) -> Bool {
        for newMusicFilePath in newMusicFilePaths {
            guard M3U8Service.addMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath) else { continue }
        }
        return true
    }
    
    static func insertWillPlay(newMusicFilePaths: [String], at index: Int) -> Bool {
        for newMusicFilePath in newMusicFilePaths.reversed() {
            guard M3U8Service.insertMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath, index: index) else { continue }
        }
        return true
    }
    
    static func moveWillPlay(from: IndexSet, to: Int) -> Bool {
        var filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(2)
        filePaths.move(fromOffsets: from, toOffset: to)
        return M3U8Service.updateM3U8(filePath: filePath, contents: filePaths)
    }
    
    static func sortWillPlay(playMode: PlayDataStore.PlayMode, filePaths: [String]) -> Bool {
        var filePaths = filePaths
        switch playMode {
        case .shuffle:
            filePaths.shuffle()
        case .order:
            filePaths.sort { $0 < $1 }
        case .sameRepeat:
            filePaths = []
        }
        return M3U8Service.updateM3U8(filePath: filePath, contents: filePaths)
    }
    
    //delete
    static func removeWillPlay(filePaths: [String]) -> Bool {
        for filePath in filePaths {
            guard M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath) else { continue }

        }
        return true
    }
}
