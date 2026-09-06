//
//  PathDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/30.
//

import Foundation

@MainActor
class PathDataStore: ObservableObject {
    static let shared = PathDataStore()
    @Published var musicViewNavigationPath: [MusicViewPath] = []
    @Published var artistViewNavigationPath: [ArtistViewPath] = []
    @Published var albumViewNavigationPath: [AlbumViewPath] = []
    @Published var playlistViewNavigationPath: [PlaylistViewPath] = []
    @Published var folderViewNavigationPath: [FolderViewPath] = []
    @Published var playViewNavigationPath: [PlayViewPath] = []
    
    enum MusicViewPath {
        case musicInfo, favoriteMusic, selectFavoriteMusic, setting, excludeFolderSelect, equalizer, sleepTimer
    }
    enum ArtistViewPath {
        case artistMusic, musicInfo
    }
    enum AlbumViewPath {
        case albumMusic, musicInfo
    }
    enum PlaylistViewPath {
        case playlistMusic, selectMusic, musicInfo
    }
    enum FolderViewPath {
        case folderMusic, musicInfo
    }
    enum PlayViewPath {
        case musicInfo, playFlow
    }
}
