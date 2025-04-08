//
//  PlaylistDataService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/22.
//

import Foundation
import SwiftData

class PlaylistRepository {
    static let actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    //create
    static func createPlaylist(playlistName: String) async -> Bool {
        guard M3U8Service.createM3U8(folderPath: "Playlist", fileName: playlistName) else { return false }
        let playlist = Playlist(playlistName: playlistName)
        await actor.insert(playlist)
        return true
    }
    
    //check
    static func is(filePath: String) -> Bool {
        let components = M3U8Service.getM3U8Components(filePath: filePath).filter { !$0.contains("\n") }
        return components.contains(filePath)
    }
    
    //get
    static func getPlaylists() async -> [Playlist] {
        let predicate = #Predicate<Playlist> { playlistData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
    
    static func getPlaylistMusic(filePath: String) async -> [Music] {
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).filter { !$0.contains("#") }
        var musics: [Music] = []
        for filePath in filePaths {
            let music = await FileService.getFileMetadata(filePath: filePath)
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func renamePlaylist(playlist: Playlist, newName: String) async -> Bool {
        guard M3U8Service.renameM3U8(filePath: playlist.filePath, oldName: playlist.playlistName, newName: newName) else { return false }
        let newPlaylist = playlist
        newPlaylist.playlistName = newName
        await actor.save()
        return true
    }
    
    static func addPlaylistMusics(playlist: Playlist, musicFilePaths: [String]) async -> Bool {
        for musicFilePath in musicFilePaths {
            guard M3U8Service.addMusic(M3U8FilePath: playlist.filePath, musicFilePath: musicFilePath) else { return false }
        }
        let newPlaylist = playlist
        newPlaylist.musicCount += musicFilePaths.count
        await actor.save()
        return true
    }
    
    //delete
    static func deletePlaylistMusic(playlist: Playlist, musicFilePath: String) async -> Bool {
        guard M3U8Service.removeMusic(M3U8FilePath: playlist.filePath, musicFilePath: musicFilePath) else { return false }
        let newPlaylist = playlist
        newPlaylist.musicCount -= 1
        await actor.save()
        return true
    }
    
    static func cleanUpPlaylist(playlist: Playlist) async -> Bool {
        guard M3U8Service.cleanUpM3U8(filePath: playlist.filePath) else { return false }
        let newPlaylist = playlist
        newPlaylist.musicCount = 0
        await actor.save()
        return true
    }
    
    static func deletePlaylist(playlist: Playlist) async -> Bool {
        guard M3U8Service.deleteM3U8(filePath: playlist.filePath) else { return false }
        await actor.delete(playlist)
        return true
    }
}
