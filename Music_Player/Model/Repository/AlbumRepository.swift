//
//  AlbumRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/03.
//

import Foundation

@MainActor
class AlbumRepository {
    static let albumDataStore: AlbumDataStore = .shared
    
    //create
    
    //check
    
    //get
    static func getAlbums() async -> [Album] {
        let filePaths = FileService.getAllFilePaths()
        var albums: [Album] = []
        for filePath in filePaths {
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            guard let music = await FileService.getFileMetadata(filePath: filePath) else { continue }
            if let index = albums.firstIndex(where: { $0.albumName == music.albumName }) {
                albums[index].musicCount += 1
            } else {
                albums.append(Album(albumName: music.albumName, musicCount: 1))
            }
        }
        return albums
    }
    
    static func getAlbumMusic() async -> [Music] {
        guard let albumName = albumDataStore.albumArray.selected?.albumName else { return [] }
        let filePaths = FileService.getAllFilePaths()
        var musics: [Music] = []
        for filePath in filePaths {
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            guard let music = await FileService.getFileMetadata(filePath: filePath) else { continue }
            guard music.albumName == albumName else { continue }
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func sortAndUpdateAlbumSortMode(sortMode: AlbumDataStore.AlbumSortMode) {
        switch sortMode {
        case .nameAscending:
            albumDataStore.albumArray.sort { $0.albumName < $1.albumName }
        case .nameDescending:
            albumDataStore.albumArray.sort { $0.albumName > $1.albumName }
        case .countAscending:
            albumDataStore.albumArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            albumDataStore.albumArray.sort { $0.musicCount > $1.musicCount }
        }
        UserDefaultsRepository.save(key: "AlbumSortMode", value: sortMode.rawValue)
    }
    
    static func sortAlbumArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "AlbumSortMode", as: String.self) else { return }
        guard let sortMode = AlbumDataStore.AlbumSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            albumDataStore.albumArray.sort { $0.albumName < $1.albumName }
        case .nameDescending:
            albumDataStore.albumArray.sort { $0.albumName > $1.albumName }
        case .countAscending:
            albumDataStore.albumArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            albumDataStore.albumArray.sort { $0.musicCount > $1.musicCount }
        }
    }
    
    static func sortAndUpdateAlbumMusicSortMode(sortMode: AlbumDataStore.AlbumMusicSortMode) {
        switch sortMode {
        case .nameAscending:
            albumDataStore.albumMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            albumDataStore.albumMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            albumDataStore.albumMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            albumDataStore.albumMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        UserDefaultsRepository.save(key: "AlbumMusicSortMode", value: sortMode.rawValue)
    }
    
    static func sortAlbumMusicArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "AlbumMusicSortMode", as: String.self) else { return }
        guard let sortMode = AlbumDataStore.AlbumMusicSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            albumDataStore.albumMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            albumDataStore.albumMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            albumDataStore.albumMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            albumDataStore.albumMusicArray.sort { $0.editedDate > $1.editedDate }
        }
    }
    
    //delete
    static func fileDelete(music: Music) -> Bool {
        guard FileService.fileDelete(filePath: music.filePath) else { return false }
        albumDataStore.albumMusicArray.remove(Music: music)
        return true
    }
}
