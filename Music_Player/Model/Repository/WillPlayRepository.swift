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
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath)
        for filePath in filePaths {
            if !FileService.isExistFile(filePath: filePath) {
                guard deleteWillPlay(filePath: filePath) else { return [] }
                print("DeleteSucceed")
                continue
            }
            let music = await FileService.getFileMetadata(filePath: filePath)
            musics.append(music)
        }
        return musics
    }
    
    static func nextMusic() async -> Music? {
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath)
        if let nextFilePath = filePaths.first {
            guard FileService.isExistFile(filePath: nextFilePath) else { return nil }
            return await FileService.getFileMetadata(filePath: nextFilePath)
        }
        return nil
    }
    
    //update
    static func addWillPlay(newMusicFilePaths: [String]) -> Bool {
        for newMusicFilePath in newMusicFilePaths {
            guard M3U8Service.addMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath) else { return false }
        }
        return true
    }
    
    static func insertWillPlay(newMusicFilePaths: [String], at index: Int) -> Bool {
        var filePaths = M3U8Service.getM3U8Components(filePath: filePath)
        var riversedFilePaths: [String] = []
        riversedFilePaths = newMusicFilePaths.reversed()
        for newMusicFilePath in riversedFilePaths {
            filePaths.insert(newMusicFilePath, at: index)
        }
        return true
    }
    
    static func moveWillPlay(from: IndexSet, to: Int) -> Bool {
        var filePaths = M3U8Service.getM3U8Components(filePath: filePath)
        filePaths.move(fromOffsets: from, toOffset: to)
        let content = "#EXTM3U\n" + "#WillPlay\n" + filePaths.joined(separator: "\n")
        guard FileService.updateFile(filePath: filePath, content: content) else { return false }
        return true
    }
    
    //delete
    static func deleteWillPlay(filePath: String) -> Bool {
        M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath)
    }
}
