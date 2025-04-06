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
    @Published var selectedMusic: Music? = nil
    @Published var musicsSortMode: MusicSortMode = .nameAscending
    
    enum MusicSortMode {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
    
    func arraySort(mode: MusicSortMode) {
        switch mode {
        case .nameAscending:
            musicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            musicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            musicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            musicArray.sort { $0.editedDate > $1.editedDate }
        }
        musicsSortMode = mode
    }
}
