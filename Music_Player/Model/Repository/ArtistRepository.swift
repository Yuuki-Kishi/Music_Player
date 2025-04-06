//
//  ArtistReposotory.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/03.
//

import Foundation

@MainActor
class ArtistRepository {
    //create
    
    //check
    
    //get
    static func getArtists() async -> [Artist] {
        let fileURLs = FileService.getFileURLs()
        var artists: [Artist] = []
        for fileURL in fileURLs {
            let music = await FileService.getFileMetadata(filePath: fileURL.path())
            if let index = artists.firstIndex(where: { $0.artistName == music.artistName }) {
                artists[index].musicCount += 1
            } else {
                artists.append(Artist(artistName: music.artistName, musicCount: 1))
            }
        }
        ArtistDataStore.shared.artistArraySort(mode: ArtistDataStore.shared.artistSortMode)
        return artists
    }
    
    static func getArtistMusic(artistName: String) async -> [Music] {
        let fileURLs = FileService.getFileURLs()
        var musics: [Music] = []
        for fileURL in fileURLs {
            let music = await FileService.getFileMetadata(filePath: fileURL.path())
            if music.artistName == artistName {
                musics.append(music)
            }
        }
        ArtistDataStore.shared.artistMusicArraySort(mode: ArtistDataStore.shared.artistMusicSortMode)
        return musics
    }
    
    //update
    
    //delete
    static func fileDelete(music: Music) {
        if FileService.fileDelete(filePath: music.filePath) {
            ArtistDataStore.shared.artistMusicArray.remove(item: music)
        }
    }
}
