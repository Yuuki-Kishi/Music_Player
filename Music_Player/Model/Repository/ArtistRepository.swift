//
//  ArtistReposotory.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/03.
//

import Foundation

@MainActor
class ArtistRepository {
    static let artistDataStore: ArtistDataStore = .shared
    
    //create
    
    //check
    
    //get
    static func getArtists() async -> [Artist] {
        let filePaths = FileService.getAllFilePaths()
        var artists: [Artist] = []
        for filePath in filePaths {
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            guard let music = await FileService.getFileMetadata(filePath: filePath) else { continue }
            if let index = artists.firstIndex(where: { $0.artistName == music.artistName }) {
                artists[index].musicCount += 1
            } else {
                artists.append(Artist(artistName: music.artistName, musicCount: 1))
            }
        }
        return artists
    }
    
    static func getArtistMusic() async -> [Music] {
        guard let artistName = artistDataStore.artistArray.selected?.artistName else { return [] }
        let filePaths = FileService.getAllFilePaths()
        var musics: [Music] = []
        for filePath in filePaths {
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            guard let music = await FileService.getFileMetadata(filePath: filePath) else { continue }
            guard music.artistName == artistName else { continue }
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func sortAndUpdateArtistSortMode(sortMode: ArtistDataStore.ArtistSortMode) {
        switch sortMode {
        case .nameAscending:
            artistDataStore.artistArray.sort { $0.artistName < $1.artistName }
        case .nameDescending:
            artistDataStore.artistArray.sort { $0.artistName > $1.artistName }
        case .countAscending:
            artistDataStore.artistArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            artistDataStore.artistArray.sort { $0.musicCount > $1.musicCount }
        }
        UserDefaultsRepository.save(key: "ArtistSortMode", value: sortMode.rawValue)
    }
    
    static func sortArtistArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "ArtistSortMode", as: String.self) else { return }
        guard let sortMode = ArtistDataStore.ArtistSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            artistDataStore.artistArray.sort { $0.artistName < $1.artistName }
        case .nameDescending:
            artistDataStore.artistArray.sort { $0.artistName > $1.artistName }
        case .countAscending:
            artistDataStore.artistArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            artistDataStore.artistArray.sort { $0.musicCount > $1.musicCount }
        }
    }
    
    static func sortAndUpdateArtistMusicSortMode(sortMode: ArtistDataStore.ArtistMusicSortMode) {
        switch sortMode {
        case .nameAscending:
            artistDataStore.artistMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            artistDataStore.artistMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            artistDataStore.artistMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            artistDataStore.artistMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        UserDefaultsRepository.save(key: "ArtistMusicSortMode", value: sortMode.rawValue)
    }
    
    static func sortArtistMusicArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "ArtistMusicSortMode", as: String.self) else { return }
        guard let sortMode = ArtistDataStore.ArtistMusicSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            artistDataStore.artistMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            artistDataStore.artistMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            artistDataStore.artistMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            artistDataStore.artistMusicArray.sort { $0.editedDate > $1.editedDate }
        }
    }
    
    //delete
    static func fileDelete(music: Music) -> Bool {
        guard FileService.fileDelete(filePath: music.filePath) else { return false }
        artistDataStore.artistMusicArray.remove(Music: music)
        return true
    }
}
