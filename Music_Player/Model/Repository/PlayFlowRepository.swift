//
//  PlayFlowRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/07.
//

import Foundation

@MainActor
class PlayFlowRepository {
    static let playFlowDataStore: PlayFlowDataStore = .shared
    static let playDataStore: PlayDataStore = .shared
    static let playNextFilePath: String = "System/PlayNext.m3u8"
    static let playNextMetaInfo: String = "#EXTM3U\n" + "#PlayNext"
    static let playBackFilePath: String = "System/PlayBack.m3u8"
    static let playBackMetaInfo: String = "#EXTM3U\n" + "#PlayBack"
    
    //create
    static func createPlayNextM3U8() -> Bool {
        FileService.createFile(filePath: playNextFilePath, content: playNextMetaInfo)
    }
    
    static func createPlayBackM3U8() -> Bool {
        FileService.createFile(filePath: playBackFilePath, content: playBackMetaInfo)
    }
    
    //check
    static func isExistPlayNextM3U8() -> Bool {
        FileService.isExist(path: playNextFilePath)
    }
    
    static func isExistPlayBackM3U8() -> Bool {
        FileService.isExist(path: playBackFilePath)
    }
    
    //get
    static func getPlayNextM3U8FilePaths() -> [String] {
        M3U8Service.getM3U8Components(filePath: playNextFilePath)
    }
    
    static func getPlayNextM3U8() async -> [Music] {
        var musics: [Music] = []
        for filePath in getPlayNextM3U8FilePaths() {
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            guard let music = await FileService.getFileMetadata(filePath: filePath) else { continue }
            musics.append(music)
        }
        return musics
    }
    
    static func getNextMusicFilePath() -> String? {
        guard let filePath = getPlayNextM3U8FilePaths().first else { return nil }
        guard FileService.isExist(path: filePath) else { return nil }
        return filePath
    }
    
    static func getPlayBackM3U8FilePaths() -> [String] {
        M3U8Service.getM3U8Components(filePath: playBackFilePath)
    }
    
    static func getPlayBackM3U8() async -> [Music] {
        var musics: [Music] = []
        for filePath in getPlayBackM3U8FilePaths() {
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            guard let music = await FileService.getFileMetadata(filePath: filePath) else { continue }
            musics.append(music)
        }
        return musics
    }
    
    static func getPreviousMusicFilePath() -> String? {
        guard let filePath = getPlayBackM3U8FilePaths().last else { return nil }
        guard FileService.isExist(path: filePath) else { return nil }
        return filePath
    }
    
    //update
    static func addPlayNextM3U8(filePath: String) -> Bool {
        M3U8Service.addMusic(M3U8FilePath: playNextFilePath, musicFilePath: filePath)
    }
    
    static func addPlayBackM3U8(filePath: String) -> Bool {
        M3U8Service.addMusic(M3U8FilePath: playBackFilePath, musicFilePath: filePath)
    }
    
    static func insertFirstPlayNextM3U8(filePath: String) -> Bool {
        M3U8Service.insertMusic(M3U8FilePath: playNextFilePath, musicFilePath: filePath, index: 0)
    }
    
    static func insertFirstPlayBackM3U8(filePath: String) -> Bool {
        M3U8Service.insertMusic(M3U8FilePath: playBackFilePath, musicFilePath: filePath, index: 0)
    }
    
    static func writePlayNextM3U8(filePaths: [String]) -> Bool {
        M3U8Service.updateM3U8(filePath: playNextFilePath, contents: filePaths)
    }
    
    static func writePlayBackM3U8(filePaths: [String]) -> Bool {
        M3U8Service.updateM3U8(filePath: playBackFilePath, contents: filePaths)
    }
    
    static func movePlayNextM3U8(from: IndexSet, to: Int) -> Bool {
        var filePaths = M3U8Service.getM3U8Components(filePath: playNextFilePath)
        filePaths.move(fromOffsets: from, toOffset: to)
        return M3U8Service.updateM3U8(filePath: playNextFilePath, contents: Array(filePaths))
    }
    
    static func selectPlayNextMusic(filePath: String) -> Bool {
        guard let playingMusicFilePath = playDataStore.playingMusic?.filePath else { return false }
        guard let index = playFlowDataStore.playNextMusicArray.firstIndex(where: { $0.filePath == filePath }) else { return false }
        var beforeFilePaths = Array(playFlowDataStore.playNextMusicArray[..<index]).map { $0.filePath }
        let afterFilePaths = Array(playFlowDataStore.playNextMusicArray[index...].dropFirst()).map { $0.filePath }
        beforeFilePaths.insert(playingMusicFilePath, at: 0)
        beforeFilePaths = playFlowDataStore.playBackMusicArray.map { $0.filePath } + beforeFilePaths
        let playMusic = playFlowDataStore.playNextMusicArray[index]
        PlayRepository.musicSelected(music: playMusic)
        guard M3U8Service.updateM3U8(filePath: playBackFilePath, contents: beforeFilePaths) else { return false }
        return M3U8Service.updateM3U8(filePath: playNextFilePath, contents: afterFilePaths)
    }
    
    static func selectPlayBackMusic(filePath: String) -> Bool {
        guard let playingMusicFilePath = playDataStore.playingMusic?.filePath else { return false }
        guard let index = playFlowDataStore.playBackMusicArray.firstIndex(where: { $0.filePath == filePath}) else { return false }
        let beforeFilePaths = Array(playFlowDataStore.playBackMusicArray[..<index]).map { $0.filePath }
        var afterFilePaths = Array(playFlowDataStore.playBackMusicArray[index...].dropFirst()).map { $0.filePath }
        afterFilePaths.insert(playingMusicFilePath, at: 0)
        afterFilePaths = afterFilePaths + playFlowDataStore.playNextMusicArray.map { $0.filePath }
        let playMusic = playFlowDataStore.playBackMusicArray[index]
        PlayRepository.musicSelected(music: playMusic)
        guard M3U8Service.updateM3U8(filePath: playBackFilePath, contents: beforeFilePaths) else { return false }
        return M3U8Service.updateM3U8(filePath: playNextFilePath, contents: afterFilePaths)
    }
    
    static func rearrangePlayNextM3U8() -> Bool {
        if playDataStore.isShuffle {
            playFlowDataStore.playNextMusicArray.shuffle()
            let contents = playFlowDataStore.playNextMusicArray.map { $0.filePath }
            return writePlayNextM3U8(filePaths: contents)
        } else {
            playFlowDataStore.playNextMusicArray.sort { $0.musicName < $1.musicName }
            let contents = playFlowDataStore.playNextMusicArray.map { $0.filePath }
            return writePlayNextM3U8(filePaths: contents)
        }
    }
    
    static func setPlayNextMusics(musics: [Music]) {
        var musics = musics
        if playDataStore.isShuffle {
            musics.shuffle()
            let contents = musics.map { $0.filePath }
            guard writePlayNextM3U8(filePaths: contents) else { return }
            print("setSucceeded")
        } else {
            musics.sort { $0.musicName < $1.musicName }
            let contents = musics.map { $0.filePath }
            guard writePlayNextM3U8(filePaths: contents) else { return }
            print("setSucceeded")
        }
    }
    
    //delete
    static func removePlayNextM3U8(filePath: String) -> Bool {
        var contents = getPlayNextM3U8FilePaths()
        contents.remove(item: filePath)
        return M3U8Service.updateM3U8(filePath: playNextFilePath, contents: contents)
    }
    
    static func removePlayNextFirstMusic() -> Bool {
        let contents = M3U8Service.getM3U8Components(filePath: playNextFilePath)
        return M3U8Service.updateM3U8(filePath: playNextFilePath, contents: Array(contents.dropFirst()))
    }
    
    static func removePlayBackM3U8(filePath: String) -> Bool {
        var contents = getPlayBackM3U8FilePaths()
        contents.remove(item: filePath)
        return M3U8Service.updateM3U8(filePath: playBackFilePath, contents: contents)
    }
    
    static func removePlayBackLastMusic() -> Bool {
        let contents = M3U8Service.getM3U8Components(filePath: playBackFilePath)
        return M3U8Service.updateM3U8(filePath: playBackFilePath, contents: Array(contents.dropLast()))
    }
    
    static func cleanUpPlayNextM3U8() -> Bool {
        M3U8Service.cleanUpM3U8(filePath: playNextFilePath)
    }
    
    static func cleanUpPlayBackM3U8() -> Bool {
        M3U8Service.cleanUpM3U8(filePath: playBackFilePath)
    }
}
