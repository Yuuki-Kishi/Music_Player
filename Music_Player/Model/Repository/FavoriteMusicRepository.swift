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
        guard let fileURL = FileService.documentDirectory?.appendingPathComponent(filePath) else { return false }
        let content = "#EXTM3U\n" + "#Favorite\n"
        return FileService.createFile(fileURL: fileURL, content: content)
    }
    
    //check
    static func isExistFavoriteMusicM3U8() -> Bool {
        M3U8Service.isExistM3U8(filePath: filePath)
    }
    
    static func isFavoriteMusic(filePath: String) -> Bool {
        let filePaths = M3U8Service.getM3U8Content(filePath: filePath)
        return filePaths.contains(filePath)
    }
    
    //get
    static func getFavoriteMusics() async -> [Music] {
        var musics: [Music] = []
        let filePaths = M3U8Service.getM3U8Content(filePath: filePath)
        for filePath in filePaths {
            if FileService.isExistFile(filePath: filePath) {
                let music = await FileService.getFileMetadata(filePath: filePath)
                musics.append(music)
            } else {
                if deleteFavoriteMusic(filePath: filePath) {
                    print("DeleteSucceed")
                }
            }
        }
        return musics
    }
    
    static func getSelectableMusics() async -> [Music] {
        let fileURLs = FileService.getFileURLs()
        var musics: [Music] = []
        for fileURL in fileURLs {
            let music = await FileService.getFileMetadata(filePath: fileURL.path())
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func addFavoriteMusics(newMusicFilePaths: [String]) -> Bool {
        for newMusicFilePath in newMusicFilePaths {
            if !M3U8Service.addMusic(M3U8FilePath: filePath, musicFilePath: newMusicFilePath) {
                return false
            }
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
        M3U8Service.removeMusic(M3U8FilePath: filePath, musicFilePath: filePath)
    }
    
    static func deleteAllFavoriteMusicData() -> Bool {
        createFavoriteMusicM3U8()
    }
}
