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
    @Published var selectedMusic: Music? = nil
    @Published var favoriteMusicSortMode: FavoriteMusicSortMode = .nameAscending
    
    enum FavoriteMusicSortMode {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
    
    func favoriteMusicArraySort(mode: FavoriteMusicSortMode) {
        switch mode {
        case .nameAscending:
            favoriteMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            favoriteMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            favoriteMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            favoriteMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        favoriteMusicSortMode = mode
    }
}
