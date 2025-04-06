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
        guard let fileURL = FileService.documentDirectory?.appendingPathComponent(filePath) else { return false }
        let content = "#EXTM3U\n" + "#WillPlay\n"
        return FileService.createFile(fileURL: fileURL, content: content)
    }
    
    //check
    static func isExistWillPlayM3U8() -> Bool {
        M3U8Service.isExistM3U8(filePath: filePath)
    }
    
    //get
    static func getWillPlay() async -> [Music] {
        var musics: [Music] = []
        let filePaths = M3U8Service.getM3U8Content(filePath: filePath)
        for filePath in filePaths {
            if FileService.isExistFile(filePath: filePath) {
                let music = await FileService.getFileMetadata(filePath: filePath)
                musics.append(music)
            } else {
                if deleteWillPlay(filePath: filePath) {
                    print("DeleteSucceed")
                }
            }
        }
        return musics
    }
    
    static func nextMusic() async -> Music? {
        var music: Music? = nil
        let filePaths = M3U8Service.getM3U8Content(filePath: filePath)
        if let nextFilePath = filePaths.first {
            if FileService.isExistFile(filePath: filePath) {
                music = await FileService.getFileMetadata(filePath: filePath)
            }
        }
        return music
    }
    
    //update
    static func addWillPlay(newMusicFilePaths: [String]) -> Bool {
        for newMusicFilePath in newMusicFilePaths {
            if !M3U8Service.addMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath) {
                return false
            }
        }
        return true
    }
    
    static func insertWillPlay(newMusicFilePaths: [String], at index: Int) -> Bool {
        var filePaths = M3U8Service.getM3U8Content(filePath: filePath)
        var riversedFilePaths: [String] = []
        riversedFilePaths = newMusicFilePaths.reversed()
        for newMusicFilePath in riversedFilePaths {
            filePaths.insert(newMusicFilePath, at: index)
        }
        return true
    }
    
    static func moveWillPlay(from: IndexSet, to: Int) -> Bool {
        var filePaths = M3U8Service.getM3U8Content(filePath: filePath)
        filePaths.move(fromOffsets: from, toOffset: to)
        let description = "#EXTM3U\n" + "#WillPlay\n" + filePaths.description
        guard let data = description.data(using: .utf8) else { return false }
        guard let fileURL = FileService.documentDirectory?.appendingPathComponent(filePath) else { return false }
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    @MainActor
    static func selectWillPlay(music: Music) -> Bool {
        PlayDataStore.shared.musicChoosed(music: music)
        guard let index = WillPlayDataStore.shared.willPlayMusicArray.firstIndex(of: music) else { return false }
        for i in 0 ... index {
            if deleteWillPlay(filePath: music.filePath) {
                WillPlayDataStore.shared.willPlayMusicArray.removeFirst()
            }
        }
        return true
    }
    
    //delete
    static func deleteWillPlay(filePath: String) -> Bool {
        M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath)
    }
}
