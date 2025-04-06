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
    @Published var selectedArtist: Artist? = nil
    @Published var artistMusicArray: [Music] = []
    @Published var selectedMusic: Music? = nil
    @Published var artistSortMode: ArtistSortMode = .nameAscending
    @Published var artistMusicSortMode: ArtistMusicSortMode = .nameAscending
    
    enum ArtistSortMode {
        case nameAscending, nameDescending, countAscending, countDescending
    }
    
    enum ArtistMusicSortMode {
        case nameAscending, nameDescending, dateAscending, dateDescending
    }
    
    func artistArraySort(mode: ArtistSortMode) {
        switch mode {
        case .nameAscending:
            artistArray.sort { $0.artistName < $1.artistName }
        case .nameDescending:
            artistArray.sort { $0.artistName > $1.artistName }
        case .countAscending:
            artistArray.sort { $0.musicCount < $1.musicCount }
        case .countDescending:
            artistArray.sort { $0.musicCount > $1.musicCount }
        }
        artistSortMode = mode
    }
    
    func artistMusicArraySort(mode: ArtistMusicSortMode) {
        switch mode {
        case .nameAscending:
            artistMusicArray.sort { $0.musicName < $1.musicName }
        case .nameDescending:
            artistMusicArray.sort { $0.musicName > $1.musicName }
        case .dateAscending:
            artistMusicArray.sort { $0.editedDate < $1.editedDate }
        case .dateDescending:
            artistMusicArray.sort { $0.editedDate > $1.editedDate }
        }
        artistMusicSortMode = mode
    }
}
