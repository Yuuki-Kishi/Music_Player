//
//  FavoriteMusicDataService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/22.
//

import Foundation
import SwiftData

final class FavoriteMusicDataService {
    static let shared = FavoriteMusicDataService()
    lazy var actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    func createFavoriteMusicData(music: Music) async {
        let favoriteMusicData = FavoriteMusicData(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
        await actor.insert(favoriteMusicData)
    }
    
    func deleteFavoriteMusicData(music: Music) async {
        let favoriteMusic = FavoriteMusicData(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
        await actor.delete(favoriteMusic)
    }
    
    func getAllFavoriteMusicDatas() async -> [Music] {
        let predicate = #Predicate<FavoriteMusicData> { favoriteMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        let favoriteMusicArray = await actor.get(descriptor) ?? []
        var musics = [Music]()
        for favoriteMusic in favoriteMusicArray {
            let music = Music(musicName: favoriteMusic.musicName, artistName: favoriteMusic.artistName, albumName: favoriteMusic.albumName, editedDate: favoriteMusic.editedDate, fileSize: favoriteMusic.fileSize, musicLength: favoriteMusic.musicLength, filePath: favoriteMusic.filePath)
            musics.append(music)
        }
        return musics
    }
}
