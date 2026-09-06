//
//  FavoriteMusicDataService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/22.
//

import Foundation

@MainActor
class FavoriteMusicRepository {
    static let filePath: String = "System/Favorite.m3u8"
    static let favoriteMusicDataStore: FavoriteMusicDataStore = .shared
    
    //create
    static func createFavoriteMusicM3U8() -> Bool {
        let content = "#EXTM3U\n" + "#Favorite"
        return FileService.createFile(filePath: filePath, content: content)
    }
    
    //check
    static func isExistFavoriteMusicM3U8() -> Bool {
        M3U8Service.isExistM3U8(filePath: filePath)
    }
    
    static func isFavoriteMusic(filePath: String) -> Bool {
        M3U8Service.getM3U8Components(filePath: self.filePath).contains(filePath)
    }
    
    //get
    static func getFavoriteMusics() async -> [Music] {
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath)
        var musics: [Music] = []
        for filePath in filePaths {
            guard FileService.isExist(path: filePath) else {
                guard removeFavoriteMusic(filePath: filePath) else { continue }
                print("removeSucceeded")
                continue
            }
            guard !ExcludeFolderRepository.isExclude(filePath: filePath) else { continue }
            guard let music = await FileService.getFileMetadata(filePath: filePath) else { continue }
            musics.append(music)
        }
        return musics
    }
    
    static func getSelectableMusics() async -> [Music] {
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
    static func addFavoriteMusic(newMusicFilePath: String) -> Bool {
        M3U8Service.addMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath)
    }
    
    static func updateFavoriteMusics() -> Bool {
        let musicFilePaths = favoriteMusicDataStore.selectionValue.map { $0.filePath }
        return M3U8Service.updateM3U8(filePath: filePath, contents: musicFilePaths)
    }
    
    static func toggleFavoriteMusic(filePath: String) -> Bool {
        if isFavoriteMusic(filePath: filePath) {
            return removeFavoriteMusic(filePath: filePath)
        } else {
            return addFavoriteMusic(newMusicFilePath: filePath)
        }
    }
    
    static func sortAndUpdateFavoriteMusicSortMode(sortMode: FavoriteMusicDataStore.FavoriteMusicSortMode) {
        switch sortMode {
        case .nameAscending:
            favoriteMusicDataStore.favoriteMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            favoriteMusicDataStore.favoriteMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            favoriteMusicDataStore.favoriteMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            favoriteMusicDataStore.favoriteMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        UserDefaultsRepository.save(key: "FavoriteMusicSortMode", value: sortMode.rawValue)
    }
    
    static func sortFavoriteMusicArray() {
        guard let sortModeString = UserDefaultsRepository.load(key: "FavoriteMusicSortMode", as: String.self) else { return }
        guard let sortMode = FavoriteMusicDataStore.FavoriteMusicSortMode(rawValue: sortModeString) else { return }
        switch sortMode {
        case .nameAscending:
            favoriteMusicDataStore.favoriteMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            favoriteMusicDataStore.favoriteMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            favoriteMusicDataStore.favoriteMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            favoriteMusicDataStore.favoriteMusicArray.sort { $0.editedDate > $1.editedDate }
        }
    }
    
    static func migrationFavoriteMusic() -> Bool {
        M3U8Service.moveM3U8(filePath: "Playlist/System/Favorite.m3u8", newFilePath: filePath)
    }
    
    //delete
    static func removeFavoriteMusic(filePath: String) -> Bool {
        M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath)
    }
    
    static func cleanUpFavorite() -> Bool {
        M3U8Service.cleanUpM3U8(filePath: filePath)
    }
    
    static func fileDelete(music: Music) -> Bool {
        guard FileService.fileDelete(filePath: music.filePath) else { return false }
        favoriteMusicDataStore.favoriteMusicArray.remove(Music: music)
        return true
    }
}
