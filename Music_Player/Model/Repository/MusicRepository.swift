//
//  MusicRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/29.
//

import Foundation

@MainActor
class MusicRepository {
    static let musicDataStore: MusicDataStore = .shared
    
    //create
    
    //check
    
    //get
    static func getMusics() async -> [Music] {
        let filePaths = FileService.getAllFilePaths()
        var musics: [Music] = []
        for filePath in filePaths {
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            guard let music = await FileService.getFileMetadata(filePath: filePath) else { continue }
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func sortAndUpdateMusicSortMode(sortMode: MusicDataStore.MusicSortMode) {
        switch sortMode {
        case .nameAscending:
            musicDataStore.musicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            musicDataStore.musicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            musicDataStore.musicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            musicDataStore.musicArray.sort { $0.editedDate > $1.editedDate }
        }
        UserDefaultsRepository.save(key: "MusicArraySortMode", value: sortMode.rawValue)
    }
    
    static func sortMusicArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "MusicArraySortMode", as: String.self) else { return }
        guard let sortMode = MusicDataStore.MusicSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            musicDataStore.musicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            musicDataStore.musicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            musicDataStore.musicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            musicDataStore.musicArray.sort { $0.editedDate > $1.editedDate }
        }
    }
    
    //delete
    static func fileDelete(music: Music) -> Bool {
        guard FileService.fileDelete(filePath: music.filePath) else { return false }
        musicDataStore.musicArray.remove(Music: music)
        return true
    }
}
