//
//  PlaylistDataService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/22.
//

import Foundation

class PlaylistRepository {
    static let folderPath: String = "Playlist"
    
    //create
    static func createPlaylist(playlistName: String) -> Bool {
        M3U8Service.createM3U8(folderPath: "Playlist", fileName: playlistName)
    }
    
    //check
    static func isExistsPlaylist(filePath: String) -> Bool {
        FileService.isExistFile(filePath: filePath)
    }
    
    //get
    static func getPlaylists() -> [Playlist] {
        let filePaths = M3U8Service.getM3U8s(folderPath: folderPath)
        var playlists: [Playlist] = []
        for filePath in filePaths {
            let playlistName = M3U8Service.getM3U8Name(filePath: filePath)
            let musicCount = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(2).count
            let playlist = Playlist(playlistName: playlistName, musicCount: musicCount, filePath: filePath)
            playlists.append(playlist)
        }
        return playlists
    }
    
    static func getPlaylistMusic(filePath: String) async -> [Music] {
        let filePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(2)
        var musics: [Music] = []
        for filePath in filePaths {
            let music = await FileService.getFileMetadata(filePath: filePath)
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func renamePlaylist(playlist: Playlist, newName: String) -> Bool {
        M3U8Service.renameM3U8(filePath: playlist.filePath, newName: newName)
    }
    
    static func addPlaylistMusics(playlist: Playlist, musicFilePaths: [String]) -> Playlist {
        var newPlaylist = playlist
        for musicFilePath in musicFilePaths {
            guard M3U8Service.addMusic(M3U8FilePath: playlist.filePath, musicFilePath: musicFilePath) else { continue }
            newPlaylist.musicCount += 1
        }
        return newPlaylist
    }
    
    //delete
    static func removePlaylistMusic(playlist: Playlist, musicFilePaths: [String]) -> Playlist {
        var newPlaylist = playlist
        for musicFilePath in musicFilePaths {
            guard M3U8Service.removeMusic(M3U8FilePath: playlist.filePath, musicFilePath: musicFilePath) else { continue }
            newPlaylist.musicCount -= 1
        }
        return newPlaylist
    }
    
    static func deletePlaylist(playlist: Playlist) -> Bool {
        M3U8Service.deleteM3U8(filePath: playlist.filePath)
    }
}
