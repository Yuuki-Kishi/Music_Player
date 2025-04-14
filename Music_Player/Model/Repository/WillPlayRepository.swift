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
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(index: 2)
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
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(index: 2)
        for filePath in filePaths {
            if !FileService.isExistFile(filePath: filePath) {
                guard WillPlayRepository.removeWillPlay(filePath: filePath) else { return nil }
                continue
            }
            return await FileService.getFileMetadata(filePath: filePath)
        }
        return nil
    }
    
    //update
    static func addWillPlay(newMusicFilePath: String) -> Bool {
        M3U8Service.addMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath)
    }
    
    static func addWillPlays(newMusicFilePaths: [String]) -> Bool {
        M3U8Service.addMusics(M3U8FilePath: filePath, musicFilePaths: newMusicFilePaths)
    }
    
    static func insertWillPlay(newMusicFilePath: String, at index: Int) -> Bool {
        M3U8Service.insertMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath, index: index)
    }
    
    static func insertWillPlays(newMusicFilePaths: [String], at index: Int) -> Bool {
        M3U8Service.insertMusics(M3U8FilePath: filePath, musicFilePaths: newMusicFilePaths, index: index)
    }
    
    static func moveWillPlay(from: IndexSet, to: Int) -> Bool {
        var filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(index: 2)
        filePaths.move(fromOffsets: from, toOffset: to)
        return M3U8Service.updateM3U8(filePath: filePath, contents: filePaths)
    }
    
    @MainActor
    static func sortWillPlay(playMode: PlayDataStore.PlayMode, playGroup: PlayDataStore.PlayGroup) -> Bool {
        var musics: [Music] = []
        switch playGroup {
        case .music:
            musics = MusicDataStore.shared.musicArray
        case .artist:
            musics = ArtistDataStore.shared.artistMusicArray
        case .album:
            musics = AlbumDataStore.shared.albumMusicArray
        case .playlist:
            musics = PlaylistDataStore.shared.playlistMusicArray
        case .folder:
            musics = FolderDataStore.shared.folderMusicArray
        case .favorite:
            musics = FavoriteMusicDataStore.shared.favoriteMusicArray
        }
        switch playMode {
        case .shuffle:
            guard let playingMusic = PlayDataStore.shared.playingMusic else { return false }
            musics.remove(item: playingMusic)
            musics.shuffle()
        case .order:
            guard let playingMusic = PlayDataStore.shared.playingMusic else { return false }
            guard let index = musics.firstIndex(where: { $0.filePath == playingMusic.filePath }) else { return false }
            musics = musics.droppedFisrt(index: index + 1)
        case .sameRepeat:
            musics = []
        }
        let filePaths = musics.map { $0.filePath }
        return M3U8Service.updateM3U8(filePath: filePath, contents: filePaths)
    }
    
    //delete
    static func removeWillPlay(filePath: String) -> Bool {
        M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath)
    }
    
    static func removeWillPlays(filePaths: [String]) -> Bool {
        M3U8Service.removeMusics(M3U8FilePath: self.filePath, musicFilePaths: filePaths)
    }
    
    static func cleanUpWillPlay() -> Bool {
        M3U8Service.cleanUpM3U8(filePath: filePath)
    }
}
