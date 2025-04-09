//
//  FavoriteMusicDataService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/22.
//

import Foundation

class FavoriteMusicRepository {
    static let filePath: String = "Playlist/System/Favorite.m3u8"
    
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
        let components = M3U8Service.getM3U8Components(filePath: self.filePath).filter { !$0.contains("\n") }
        return components.contains(filePath)
    }
    
    //get
    static func getFavoriteMusics() async -> [Music] {
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).filter { !$0.contains("\n") }
        var musics: [Music] = []
        for filePath in filePaths {
            if !FileService.isExistFile(filePath: filePath) {
                guard deleteFavoriteMusic(filePath: filePath) else { return [] }
                print("DeleteSucceed")
                continue
            }
            let music = await FileService.getFileMetadata(filePath: filePath)
            musics.append(music)
        }
        return musics
    }
    
    static func getSelectableMusics() async -> [Music] {
        let filePaths = FileService.getAllFilePaths()
        var musics: [Music] = []
        for filePath in filePaths {
            let music = await FileService.getFileMetadata(filePath: filePath)
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func addFavoriteMusics(newMusicFilePaths: [String]) -> Bool {
        for newMusicFilePath in newMusicFilePaths {
            guard M3U8Service.addMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath) else { continue }
        }
        return true
    }
    
    static func toggleFavoriteMusic(filePath: String) -> Bool {
        if isFavoriteMusic(filePath: filePath) {
            return deleteFavoriteMusic(filePath: filePath)
        } else {
            return addFavoriteMusics(newMusicFilePaths: [filePath])
        }
    }
    
    //delete
    static func deleteFavoriteMusic(filePath: String) -> Bool {
        M3U8Service.removeMusic(M3U8FilePath: self.filePath, musicFilePath: filePath)
    }
    
    static func cleanUpFavorite() -> Bool {
        M3U8Service.cleanUpM3U8(filePath: filePath)
    }
}
