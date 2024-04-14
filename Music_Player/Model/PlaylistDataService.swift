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
    
    func createPlaylistDataWithMusics(playlistName: String, musics: [Music]) async {
        let playlistData = PlaylistData(playlistName: playlistName, musicCount: musics.count, musics: musics)
        await actor.insert(playlistData)
    }
    
    func addMusicToPlaylist(playlistId: UUID, music: Music) async {
        if let playlist = await readPlaylistDatas().first(where: {$0.playlistId == playlistId}) {
            var musics = playlist.musics
            if !returnIsContain(music: music, musics: musics) {
                musics.append(music)
                playlist.musics = musics
                playlist.musicCount += 1
                await actor.save()
            }
        }
    }
    
    func readPlaylistDatas() async -> [PlaylistData] {
        let predicate = #Predicate<PlaylistData> { playlistData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
    
    func readPlaylistMusics(playlistId: UUID) async -> [Music] {
        var musics = [Music]()
        if let playlistData = await readPlaylistDatas().first(where: {$0.playlistId == playlistId}) {
            musics = playlistData.musics
            print(playlistData.musics)
        }
        return musics
    }
    
    func updatePlaylistData(playlistId: UUID, playlistName: String, musics: [Music]) async {
        let playlistDatas = await readPlaylistDatas()
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
    
    func returnIsContain(music: Music, musics: [Music]) -> Bool {
        var isContain = false
        for contentMusic in musics {
            if music.filePath == contentMusic.filePath {
                isContain = true
            }
        }
        return isContain
    }
}
