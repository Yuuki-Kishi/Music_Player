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
    @Published var selectedAlbumName: String? = nil
    @Published var albumMusicArray: [Music] = []
    @Published var selectedMusicFilePath: String? = nil
    @Published var albumSortMode: AlbumSortMode = .nameAscending
    @Published var albumMusicSortMode: AlbumMusicSortMode = .nameAscending
    @Published var isLoading: Bool = false
    @Published var isShowAddPlaylistView: Bool = false
    
    enum AlbumSortMode: String {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    
    enum AlbumMusicSortMode: String {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
}
