//
//  PlaylistDataService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/22.
//

import Foundation
import SwiftData

final class PlaylistDataService {
    static let shared = PlaylistDataService()
    lazy var actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    func createPlaylistData(playlistName: String) async {
        let playlistData = PlaylistData(playlistName: playlistName)
        await actor.insert(playlistData)
    }
    
    func updatePlaylistData(playlistId: UUID, playlistName: String, musics: [Music]) async {
        let playlistDatas = await getAllFavoriteMusicDatas()
        if let playlistData = playlistDatas.first(where: {$0.playlistId == playlistId}) {
            playlistData.playlistName = playlistName
            playlistData.musicCount = musics.count
            playlistData.musics = musics
        }
        await actor.save()
    }
    
    func deletePlaylistData(playlistData: PlaylistData) async {
        await actor.delete(playlistData)
    }
    
    func getAllFavoriteMusicDatas() async -> [PlaylistData] {
        let predicate = #Predicate<PlaylistData> { playlistData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
}
