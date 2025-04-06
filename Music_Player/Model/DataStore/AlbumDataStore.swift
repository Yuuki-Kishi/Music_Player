//
//  AlbumDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/29.
//

import Foundation

@MainActor
class AlbumDataStore: ObservableObject {
    static let shared = AlbumDataStore()
    @Published var albumArray: [Album] = []
    @Published var selectedAlbum: Album? = nil
    @Published var albumMusicArray: [Music] = []
    @Published var selectedMusic: Music? = nil
    @Published var albumSortMode: AlbumSortMode = .nameAscending
    @Published var albumMusicSortMode: AlbumMusicSortMode = .nameAscending
    
    enum AlbumSortMode {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    
    enum AlbumMusicSortMode {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
    
    func albumArraySort(mode: AlbumSortMode) {
        switch mode {
        case .nameAscending:
            albumArray.sort { $0.albumName < $1.albumName }
        case .nameDescending:
            albumArray.sort { $0.albumName > $1.albumName }
        case .countAscending:
            albumArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            albumArray.sort { $0.musicCount > $1.musicCount }
        }
        albumSortMode = mode
    }
    
    func albumMusicArraySort(mode: AlbumMusicSortMode) {
        switch mode {
        case .nameAscending:
            albumMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            albumMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            albumMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            albumMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        albumMusicSortMode = mode
    }
}
