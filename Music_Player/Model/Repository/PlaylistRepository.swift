//
//  PlaylistDataService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/22.
//

import Foundation

class PlaylistRepository {
    static let folderPath: String = "Playlist/"
    
    //create
    static func createPlaylist(playlistName: String) -> Bool {
        M3U8Service.createM3U8(folderPath: "Playlist", fileName: playlistName)
    }
    
    //check
    static func isExistsPlaylist(filePath: String) -> Bool {
        FileService.isExistFile(filePath: filePath)
    }
    
    static func isIncludeMusic(playlistFilePath: String, musicFilePath: String) -> Bool {
        let playlistMusics = M3U8Service.getM3U8Components(filePath: playlistFilePath)
        return playlistMusics.contains(musicFilePath)
    }
    
    //get
    static func getPlaylists() -> [Playlist] {
        let filePaths = M3U8Service.getM3U8FilePaths(folderPath: folderPath)
        var playlists: [Playlist] = []
        for filePath in filePaths {
            let playlistName = M3U8Service.getM3U8Name(filePath: folderPath + filePath)
            let musicCount = M3U8Service.getM3U8Components(filePath: folderPath + filePath).droppedFisrt(index: 2).count
            let playlist = Playlist(playlistName: playlistName, musicCount: musicCount, filePath: folderPath + filePath)
            playlists.append(playlist)
        }
        return playlists
    }
    
    static func getPlaylistMusic(filePath: String) async -> [Music] {
        let musicFilePaths = M3U8Service.getM3U8Components(filePath: filePath).droppedFisrt(index: 2)
        var musics: [Music] = []
        for musicFilePath in musicFilePaths {
            if !FileService.isExistFile(filePath: musicFilePath) {
                guard removePlaylistMusic(playlistFilePath: filePath, musicFilePath: musicFilePath) else { return [] }
                print("removeSucceeded")
                continue
            }
            let music = await FileService.getFileMetadata(filePath: musicFilePath)
            musics.append(music)
        }
        return musics
    }
    
    //update
    static func renamePlaylist(playlist: Playlist, newName: String) -> Playlist {
        let filePath = playlist.filePath
        let newFilePath = folderPath + newName + ".m3u8"
        var newPlaylist = playlist
        newPlaylist.playlistName = newName
        newPlaylist.filePath = newFilePath
        guard M3U8Service.renameM3U8(filePath: filePath, newFilePath: newFilePath) else { return Playlist() }
        return newPlaylist

    }
    
    static func addPlaylistMusic(playlistFilePath: String, musicFilePath: String) -> Bool {
        M3U8Service.addMusic(M3U8FilePath: playlistFilePath, musicFilePath: musicFilePath)
    }
    
    static func updatePlaylistMusics(playlistFilePath: String, musicFilePaths: [String]) -> Bool {
        M3U8Service.updateM3U8(filePath: playlistFilePath, contents: musicFilePaths)
    }
    
    //delete
    static func removePlaylistMusic(playlistFilePath: String, musicFilePath: String) -> Bool {
        M3U8Service.removeMusic(M3U8FilePath: playlistFilePath, musicFilePath: musicFilePath)
    }
    
    static func deletePlaylist(playlistFilePath: String) -> Bool {
        M3U8Service.deleteM3U8(filePath: playlistFilePath)
    }
}
