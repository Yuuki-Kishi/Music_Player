//
//  PlayedRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/06.
//

import Foundation

class PlayedRepository {
    static let filePath: String = "Playlist/System/Played.m3u8"
    
    //create
    static func createPlayedM3U8() -> Bool {
        let filePath = "Playlist/System/Played.m3u8"
        let content = "#EXTM3U\n" + "#WillPlay"
        return FileService.createFile(filePath: filePath, content: content)
    }
    
    //check
    static func isExistPlayedM3U8() -> Bool {
        M3U8Service.isExistM3U8(filePath: filePath)
    }
    
    //get
    static func getPlayed() async -> [Music] {
        var musics: [Music] = []
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(2)
        for filePath in filePaths {
            if !FileService.isExistFile(filePath: filePath) {
                guard M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath) else { continue }
                print("removeSucceeded")
            }
            let music = await FileService.getFileMetadata(filePath: filePath)
            musics.append(music)
        }
        return musics
    }
    
    static func previousMusic() async -> Music? {
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(2)
        if let nextFilePath = filePaths.last {
            guard FileService.isExistFile(filePath: nextFilePath) else { return nil }
            return await FileService.getFileMetadata(filePath: nextFilePath)
        }
        return nil
    }
    
    //update
    static func addPlayed(newMusicFilePaths: [String]) -> Bool {
        for newMusicFilePath in newMusicFilePaths {
            guard M3U8Service.addMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath) else { continue }
        }
        return true
    }
    
    static func insertPlayed(newMusicFilePaths: [String], at index: Int) -> Bool {
        for newMusicFilePath in newMusicFilePaths.reversed() {
            guard M3U8Service.insertMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath, index: index) else { continue }
        }
        return true
    }
    
    static func movePlayed(from: IndexSet, to: Int) -> Bool {
        var filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(2)
        filePaths.move(fromOffsets: from, toOffset: to)
        return M3U8Service.updateM3U8(filePath: filePath, contents: filePaths)
    }
    
    //delete
    static func removePlayed(filePaths: [String]) -> Bool {
        for filePath in filePaths {
            guard M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath) else { continue }
        }
        return true
    }
    
    static func cleanUpPlayed() -> Bool {
        M3U8Service.cleanUpM3U8(filePath: filePath)
    }
}
