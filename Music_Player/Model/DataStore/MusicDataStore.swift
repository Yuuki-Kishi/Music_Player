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
    @Published var musicArray: [Music] = []
    @Published var selectedMusicFilePath: String? = nil
    @Published var musicArraySortMode: MusicSortMode = .nameAscending
    @Published var isLoading: Bool = false
    @Published var isShowAddPlaylistView: Bool = false
    
    enum MusicSortMode: String {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
}
