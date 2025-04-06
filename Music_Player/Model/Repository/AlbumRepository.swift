//
//  AlbumRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/03.
//

import Foundation

@MainActor
class AlbumRepository {
    //create
    
    //check
    
    //get
    static func getAlbums() async -> [Album] {
        let fileURLs = FileService.getFileURLs()
        var albums: [Album] = []
        for fileURL in fileURLs {
            let music = await FileService.getFileMetadata(filePath: fileURL.path())
            if let index = albums.firstIndex(where: { $0.albumName == music.albumName }) {
                albums[index].musicCount += 1
            } else {
                albums.append(Album(albumName: music.albumName, musicCount: 1))
            }
        }
        AlbumDataStore.shared.albumArraySort(mode: AlbumDataStore.shared.albumSortMode)
        return albums
    }
    
    static func getAlbumMusic(albumName: String) async -> [Music] {
        let fileURLs = FileService.getFileURLs()
        var musics: [Music] = []
        for fileURL in fileURLs {
            let music = await FileService.getFileMetadata(filePath: fileURL.path())
            if music.albumName == albumName {
                musics.append(music)
            }
        }
        AlbumDataStore.shared.albumMusicArraySort(mode: AlbumDataStore.shared.albumMusicSortMode)
        return musics
    }
    
    //update
    
    //delete
    static func fileDelete(music: Music) {
        if FileService.fileDelete(filePath: music.filePath) {
            AlbumDataStore.shared.albumMusicArray.remove(item: music)
        }
    }
}
