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
        let favoriteMusicData = FavoriteMusicData(music: music)
        await actor.insert(favoriteMusicData)
    }
    
    func readFavoriteMusics() async -> [Music] {
        let predicate = #Predicate<FavoriteMusicData> { favoriteMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        let favoriteMusicArray = await actor.get(descriptor) ?? []
        var musics = [Music]()
        for favoriteMusic in favoriteMusicArray {
            let music = favoriteMusic.music
            musics.append(music)
        }
        return musics
    }
    
    func readFavoriteMusicDatas() async -> [FavoriteMusicData] {
        let predicate = #Predicate<FavoriteMusicData> { favoriteMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
    
    func updateFavoriteMusicData(oldMusic: Music, newMusic: Music) async {
        if let favoriteMusicData = await readFavoriteMusicDatas().first(where: {$0.music.filePath == oldMusic.filePath}) {
            favoriteMusicData.music = newMusic
            await actor.save()
        }
    }
    
    func deleteFavoriteMusicData(music: Music) async {
        if let favoriteMusicData = await readFavoriteMusicDatas().first(where: {$0.music.filePath == music.filePath}) {
            await actor.delete(favoriteMusicData)
        }
    }
    
    func deleteAllFavoriteMusicData() async {
        for favoriteMusic in await readFavoriteMusics() {
            await deleteFavoriteMusicData(music: favoriteMusic)
        }
    }
}
