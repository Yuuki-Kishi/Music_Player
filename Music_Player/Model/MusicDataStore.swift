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
    @Published var artistArray = [Artist]()
    @Published var albumArray = [Album]()
    @Published var folderArray = [Folder]()
    @Published var listMusicArray = [Music]()
    @Published var sortMode = 0
    let fileService = FileService()
    enum musicSortMode {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
    enum artistSortMode {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    enum albumSortMode {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    enum folderSortMode {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    
    func getFile() async {
        musicArray = []
        let isDirectory = fileService.directoryCheck()
        if !isDirectory { fileService.makeDirectory() }
        let fileURLs = fileService.getFiles()
        folderArray = fileService.containFolder(fileURLs: fileURLs)
        musicArray = await fileService.collectFile(fileURLs: fileURLs)
        musicSort(method: .nameAscending)
    }
    
    func artistSelection() {
        artistArray = []
        for music in musicArray {
            let artistName = music.artistName ?? "不明なアーティスト"
            let contain = artistArray.contains(where: {$0.artistName == artistName})
            if contain {
                let index = artistArray.firstIndex(where: {$0.artistName == artistName})!
                artistArray[index].musicCount += 1
            } else {
                let artist = Artist(artistName: artistName, musicCount: 1)
                artistArray.append(artist)
            }
        }
        artistArray.sort {$0.artistName < $1.artistName}
    }
    
    func collectArtistMusic(artist: String) {
        listMusicArray = []
        for music in musicArray {
            let artistName = music.artistName!
            if artistName == artist { listMusicArray.append(music) }
        }
    }
    
    func albumSelection() {
        albumArray = []
        for music in musicArray {
            let albumName = music.albumName ?? "不明なアルバム"
            let contain = albumArray.contains(where: {$0.albumName == albumName})
            if contain {
                let index = albumArray.firstIndex(where: {$0.albumName == albumName})!
                albumArray[index].musicCount += 1
            } else {
                let artist = Album(albumName: albumName, musicCount: 1)
                albumArray.append(artist)
            }
        }
        albumArray.sort {$0.albumName < $1.albumName}
    }
    
    func collectAlbumMusic(album: String) {
        listMusicArray = []
        for music in musicArray {
            let artistName = music.albumName!
            if artistName == album { listMusicArray.append(music) }
        }
    }
    
    func collectFolderMusic(folder: String) {
        listMusicArray = []
        for music in musicArray {
            let filePath = music.filePath
            let fileURL = URL(filePath: filePath!)
            var pathPeces = fileURL.pathComponents
            pathPeces.removeLast()
            if pathPeces.count == 1 { pathPeces.append("Documents") }
            let directoryName = pathPeces.last
            if directoryName == folder { listMusicArray.append(music)}
        }
    }
    
    func fileDelete(filePath: String?) async {
        if let index = musicArray.firstIndex(where: {$0.filePath == filePath}) {
            fileService.fileDelete(shortFilePath: filePath)
            musicArray.remove(at: index)
            musicSort(method: .nameAscending)
        }
    }
    
    func musicSort(method: musicSortMode) {
        switch method {
        case .nameAscending:
            musicArray.sort {$0.musicName ?? "" < $1.musicName ?? ""}
        case .nameDescending:
            musicArray.sort {$0.musicName ?? "" > $1.musicName ?? ""}
        case .dateAscending:
            musicArray.sort {$0.editedDate ?? Date() < $1.editedDate ?? Date()}
        case .dateDescending:
            musicArray.sort {$0.editedDate ?? Date() > $1.editedDate ?? Date()}
        }
    }
    
    func listMusicSort(method: musicSortMode) {
        switch method {
        case .nameAscending:
            listMusicArray.sort {$0.musicName! < $1.musicName!}
        case .nameDescending:
            listMusicArray.sort {$0.musicName! > $1.musicName!}
        case .dateAscending:
            listMusicArray.sort {$0.editedDate ?? Date() < $1.editedDate ?? Date()}
        case .dateDescending:
            listMusicArray.sort {$0.editedDate ?? Date() > $1.editedDate ?? Date()}
        }
    }
    
    func artistSort(method: artistSortMode) {
        switch method {
        case .nameAscending:
            artistArray.sort {$0.artistName < $1.artistName}
        case .nameDescending:
            artistArray.sort {$0.artistName > $1.artistName}
        case .countAscending:
            artistArray.sort {$0.musicCount < $1.musicCount}
        case .countDescending:
            artistArray.sort {$0.musicCount > $1.musicCount}
        }
    }
    
    func albumSort(method: albumSortMode) {
        switch method {
        case .nameAscending:
            albumArray.sort {$0.albumName < $1.albumName}
        case .nameDescending:
            albumArray.sort {$0.albumName > $1.albumName}
        case .countAscending:
            albumArray.sort {$0.musicCount < $1.musicCount}
        case .countDescending:
            albumArray.sort {$0.musicCount > $1.musicCount}
        }
    }
    
    func folderSort(method: folderSortMode) {
        switch method {
        case .nameAscending:
            folderArray.sort {$0.folderName < $1.folderName}
        case .nameDescending:
            folderArray.sort {$0.folderName > $1.folderName}
        case .countAscending:
            folderArray.sort {$0.musicCount < $1.musicCount}
        case .countDescending:
            folderArray.sort {$0.musicCount > $1.musicCount}
        }
    }
}
