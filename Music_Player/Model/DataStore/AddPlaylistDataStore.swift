//
//  AddPlaylistDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/14.
//

import Foundation

@MainActor
class AddPlaylistDataStore: ObservableObject {
    static let shared = AddPlaylistDataStore()
    @Published var playlistArray: [Playlist] = []
    @Published var isLoading: Bool = false
}
