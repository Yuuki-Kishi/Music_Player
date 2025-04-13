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
    @Published var musicArraySortMode: MusicSortMode = .nameAscending
    
    enum MusicSortMode: String {
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
        musicArraySortMode = mode
    }
    
    func saveSortMode() {
        UserDefaultsRepository.saveSortMode(sortMode: musicArraySortMode.rawValue, key: "MusicSortMode")
    }
    
    func loadSort() {
        let sortModeString = UserDefaultsRepository.loadSortMode(key: "MusicSortMode") ?? "nameAscending"
        guard let sortMode = MusicSortMode(rawValue: sortModeString) else { return }
        arraySort(mode: sortMode)
    }
}
