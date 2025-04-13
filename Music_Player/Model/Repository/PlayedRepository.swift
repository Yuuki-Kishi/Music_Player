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
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(index: 2)
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
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(index: 2)
        if let nextFilePath = filePaths.last {
            guard FileService.isExistFile(filePath: nextFilePath) else { return nil }
            return await FileService.getFileMetadata(filePath: nextFilePath)
        }
        return nil
    }
    
    //update
    static func addPlayed(newMusicFilePath: String) -> Bool {
        M3U8Service.addMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath)
    }
    
    static func addPlayeds(newMusicFilePaths: [String]) -> Bool {
        M3U8Service.addMusics(M3U8FilePath: filePath, musicFilePaths: newMusicFilePaths)
    }
    
    static func insertPlayed(newMusicFilePath: String, at index: Int) -> Bool {
        M3U8Service.insertMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath, index: index)
    }
    
    static func insertPlayeds(newMusicFilePaths: [String], at index: Int) -> Bool {
        M3U8Service.insertMusics(M3U8FilePath: filePath, musicFilePaths: newMusicFilePaths, index: index)
    }
    
    static func movePlayed(from: IndexSet, to: Int) -> Bool {
        var filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(index: 2)
        filePaths.move(fromOffsets: from, toOffset: to)
        return M3U8Service.updateM3U8(filePath: filePath, contents: filePaths)
    }
    
    //delete
    static func removePlayed(filePath: String) -> Bool {
        M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath)
    }
    
    static func removePlayeds(filePaths: [String]) -> Bool {
        M3U8Service.removeMusics(M3U8FilePath: self.filePath, musicFilePaths: filePaths)
    }
    
    static func cleanUpPlayed() -> Bool {
        M3U8Service.cleanUpM3U8(filePath: filePath)
    }
}
