//
//  MusicDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/17.
//

import Foundation

@MainActor
class MusicDataStore: ObservableObject {
    static let shared = MusicDataStore()
    @Published var musicArray = [Music]()
    @Published var folderArray = [Folder]()
    let fileService = FileService()
    
    func getFile() async {
        musicArray = []
        let isDirectory = fileService.directoryCheck()
        if !isDirectory { fileService.makeDirectory() }
        let fileURLs = fileService.getFiles()
        folderArray = fileService.containFolder(fileURLs: fileURLs)
        musicArray = await fileService.collectFile(fileURLs: fileURLs)
        sort(method: 0)
    }
    
    func artistSelection() -> Array<Artist> {
        var artistArray =  [Artist]()
        for music in musicArray {
            let artistName = music.artistName
            let contain = artistArray.contains(where: {$0.artistName == artistName})
            if contain {
                let index = artistArray.firstIndex(where: {$0.artistName == artistName})!
                artistArray[index].musicCount += 1
            } else {
                let artist = Artist(artistName: artistName, musicCount: 1)
                artistArray.append(artist)
            }
        }
        return artistArray
    }
    
    func collectArtistMusic(artist: String) -> Array<Music> {
        var listMusicArray = [Music]()
        for music in musicArray {
            let artistName = music.artistName
            if artistName == artist { listMusicArray.append(music) }
        }
        return listMusicArray
    }
    
    func albumSelection() -> Array<Album> {
        var albumArray = [Album]()
        for music in musicArray {
            let albumName = music.albumName
            let contain = albumArray.contains(where: {$0.albumName == albumName})
            if contain {
                let index = albumArray.firstIndex(where: {$0.albumName == albumName})!
                albumArray[index].musicCount += 1
            } else {
                let artist = Album(albumName: albumName, musicCount: 1)
                albumArray.append(artist)
            }
        }
        return albumArray
    }
    
    func collectAlbumMusic(album: String) -> Array<Music> {
        var listMusicArray = [Music]()
        for music in musicArray {
            let artistName = music.albumName
            if artistName == album { listMusicArray.append(music) }
        }
        return listMusicArray
    }
    
//    func collectPlaylistMusic(playlistName: String) async -> Array<Music> {
//        let index = playlistArray.firstIndex(where: {$0.playlistName == playlistName})!
//        var fileURLs = [URL]()
//        for music in playlistArray[index].musics {
//            fileURLs.append(URL(fileURLWithPath: music.filePath))
//        }
//        let listMusicArray = await fileService.collectFile(fileURLs: fileURLs)
//        return listMusicArray
//    }
    
    func sort(method: Int) {
        switch method {
        case 0:
            musicArray.sort {$0.musicName < $1.musicName}
        case 1:
            musicArray.sort {$0.musicName > $1.musicName}
        case 2:
            musicArray.sort {$0.editedDate < $1.editedDate}
        case 3:
            musicArray.sort {$0.editedDate > $1.editedDate}
        default:
            break
        }
    }
}
