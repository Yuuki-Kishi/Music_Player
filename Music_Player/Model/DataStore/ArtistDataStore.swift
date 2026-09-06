//
//  ArtistDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/29.
//

import Foundation

@MainActor
class ArtistDataStore: ObservableObject {
    static let shared = ArtistDataStore()
    @Published var artistArray: [Artist] = []
    @Published var selectedArtistName: String? = nil
    @Published var artistMusicArray: [Music] = []
    @Published var selectedMusicFilePath: String? = nil
    @Published var artistSortMode: ArtistSortMode = .nameAscending
    @Published var artistMusicSortMode: ArtistMusicSortMode = .nameAscending
    @Published var isLoading: Bool = false
    @Published var isShowAddPlaylistView: Bool = false
    
    enum ArtistSortMode: String {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    
    enum ArtistMusicSortMode: String {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
}
