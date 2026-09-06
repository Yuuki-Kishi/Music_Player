//
//  PlaylistDataService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/22.
//

import Foundation

@MainActor
class PlaylistRepository {
    static let folderPath: String = "Playlist/"
    static let playlistDataStore: PlaylistDataStore = .shared
    
    //create
    static func createPlaylist(playlistName: String) -> Bool {
        M3U8Service.createM3U8(folderPath: "Playlist", fileName: playlistName)
    }
    
    //check
    static func isExistsPlaylist(filePath: String) -> Bool {
        FileService.isExist(path: filePath)
    }
    
    //get
    
    static func getPlaylist(filePath: String) -> Playlist? {
        guard let playlistName = M3U8Service.getM3U8Name(filePath: filePath) else { return nil }
        let musicCount = M3U8Service.getM3U8Components(filePath: filePath).count
        return Playlist(playlistName: playlistName, musicCount: musicCount, filePath: filePath)
    }
    
    static func getPlaylists() -> [Playlist] {
        let filePaths = M3U8Service.getM3U8FilePaths(folderPath: folderPath)
        var playlists: [Playlist] = []
        for filePath in filePaths {
            guard let playlistName = M3U8Service.getM3U8Name(filePath: filePath) else { continue }
            let musicCount = M3U8Service.getM3U8Components(filePath: filePath).count
            let playlist = Playlist(playlistName: playlistName, musicCount: musicCount, filePath: filePath)
            playlists.append(playlist)
        }
        return playlists
    }
    
    static func getPlaylistMusic() async -> [Music] {
        guard let playlistFilePath = playlistDataStore.playlistArray.selected?.filePath else { return [] }
        let musicFilePaths = M3U8Service.getM3U8Components(filePath: playlistFilePath)
        var musics: [Music] = []
        for musicFilePath in musicFilePaths {
            guard FileService.isExist(path: musicFilePath) else {
                guard removePlaylistMusic(playlistFilePath: playlistFilePath, musicFilePath: musicFilePath) else { continue }
                print("removeSucceeded")
                continue
            }
            guard let music = await FileService.getFileMetadata(filePath: musicFilePath) else { continue }
            musics.append(music)
        }
        return musics
    }
    
    static func getIncludeMusicFilePaths() -> [String] {
        guard let playlistFilePath = playlistDataStore.playlistArray.selected?.filePath else { return [] }
        return Array(M3U8Service.getM3U8Components(filePath: playlistFilePath))
    }
    
    //update
    static func renamePlaylist(playlist: Playlist, newName: String) -> Playlist? {
        let filePath = playlist.filePath
        let newFilePath = folderPath + newName + ".m3u8"
        guard M3U8Service.renameM3U8(filePath: filePath, newFilePath: newFilePath) else { return nil }
        return getPlaylist(filePath: newFilePath)
    }
    
    static func addPlaylistMusic(playlistFilePath: String, musicFilePath: String) -> Bool {
        M3U8Service.addMusic(M3U8FilePath: playlistFilePath, musicFilePath: musicFilePath)
    }
    
    static func updatePlaylistMusics() -> Bool {
        guard let filePath = playlistDataStore.playlistArray.selected?.filePath else { return false }
        let musicFilePaths = playlistDataStore.selectionValue.map { $0.filePath }
        return M3U8Service.updateM3U8(filePath: filePath, contents: musicFilePaths)
    }
    
    static func sortAndUpdatePlaylistSortMode(sortMode: PlaylistDataStore.PlaylistSortMode) {
        switch sortMode {
        case .nameAscending:
            playlistDataStore.playlistArray.sort { $0.playlistName < $1.playlistName }
        case .nameDescending:
            playlistDataStore.playlistArray.sort { $0.playlistName > $1.playlistName }
        case .countAscending:
            playlistDataStore.playlistArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            playlistDataStore.playlistArray.sort { $0.musicCount > $1.musicCount }
        }
        UserDefaultsRepository.save(key: "playlistSortMode", value: sortMode.rawValue)
    }
    
    static func sortPlaylistArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "playlistSortMode", as: String.self) else { return }
        guard let sortMode = PlaylistDataStore.PlaylistSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            playlistDataStore.playlistArray.sort { $0.playlistName < $1.playlistName }
        case .nameDescending:
            playlistDataStore.playlistArray.sort { $0.playlistName > $1.playlistName }
        case .countAscending:
            playlistDataStore.playlistArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            playlistDataStore.playlistArray.sort { $0.musicCount > $1.musicCount }
        }
    }
    
    static func sortAndUpdatePlaylistMusicSortMode(sortMode: PlaylistDataStore.PlaylistMusicSortMode) {
        switch sortMode {
        case .nameAscending:
            playlistDataStore.playlistMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            playlistDataStore.playlistMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            playlistDataStore.playlistMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            playlistDataStore.playlistMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        UserDefaultsRepository.save(key: "playlistMusicSortMode", value: sortMode.rawValue)
    }
    
    static func sortPlaylistMusicArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "playlistMusicSortMode", as: String.self) else { return }
        guard let sortMode = PlaylistDataStore.PlaylistMusicSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            playlistDataStore.playlistMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            playlistDataStore.playlistMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            playlistDataStore.playlistMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            playlistDataStore.playlistMusicArray.sort { $0.editedDate > $1.editedDate }
        }
    }
    
    //delete
    static func removePlaylistMusic(playlistFilePath: String, musicFilePath: String) -> Bool {
        M3U8Service.removeMusic(M3U8FilePath: playlistFilePath, musicFilePath: musicFilePath)
    }
    
    static func fileDelete(music: Music) -> Bool {
        guard FileService.fileDelete(filePath: music.filePath) else { return false }
        playlistDataStore.playlistMusicArray.remove(Music: music)
        return true
    }
    
    static func deletePlaylist(playlist: Playlist) -> Bool {
        guard M3U8Service.deleteM3U8(filePath: playlist.filePath) else { return false }
        playlistDataStore.playlistArray.remove(Playlist: playlist)
        return true
    }
}
