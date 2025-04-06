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
    static func createNewPlaylist(playlistName: String) async -> Playlist{
        let playlist = Playlist(playlistName: playlistName)
        await actor.insert(playlist)
        return playlist
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
        let filePaths = M3U8Service.getM3U8Content(filePath: filePath)
        var musics: [Music] = []
        for filePath in filePaths {
            guard let fileURL = FileService.documentDirectory?.appendingPathComponent(filePath) else { return [] }
            let music = await FileService.getFileMetadata(filePath: fileURL.path())
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func renamePlaylist(playlist: Playlist, newName: String) async {
        var newPlaylist = playlist
        newPlaylist.playlistName = newName
        await actor.save()
    }
    
    static func addPlaylistMusics(playlist: Playlist, musicFilePaths: [String]) async -> Bool {
        for musicFilePath in musicFilePaths {
            if !M3U8Service.addMusic(M3U8FilePath: playlist.filePath, musicFilePath: musicFilePath) {
                return false
            }
        }
        var newPlaylist = playlist
        newPlaylist.musicCount += musicFilePaths.count
        await actor.save()
        return true
    }
    
    //delete
    static func deletePlaylist(playlist: Playlist) async -> Bool {
        if M3U8Service.deleteM3U8(filePath: playlist.filePath) {
            await actor.delete(playlist)
            return true
        }
        return false
    }
    
    static func deletePlaylistMusic(playlist: Playlist, musicFilePath: String) async -> Bool {
        if M3U8Service.removeMusic(M3U8FilePath: playlist.filePath, musicFilePath: musicFilePath) {
            var newPlaylist = playlist
            newPlaylist.musicCount -= 1
            await actor.save()
            return true
        }
        return false
    }
}
