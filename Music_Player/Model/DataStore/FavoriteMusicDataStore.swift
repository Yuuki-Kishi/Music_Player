//
//  FavoriteMusicDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/05.
//

import Foundation

@MainActor
class FavoriteMusicDataStore: ObservableObject {
    static let shared = FavoriteMusicDataStore()
    @Published var favoriteMusicArray: [Music] = []
    @Published var selectedMusicFilePath: String? = nil
    @Published var favoriteMusicSortMode: FavoriteMusicSortMode = .nameAscending
    @Published var isLoading: Bool = false
    @Published var isShowAddPlaylistView: Bool = false
    @Published var selectionValue: Set<Music> = []
    @Published var selectableMusicArray: [Music] = []
    
    enum FavoriteMusicSortMode: String {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
}
