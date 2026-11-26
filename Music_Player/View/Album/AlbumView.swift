//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct AlbumView: View {
    @EnvironmentObject private var albumDataStore: AlbumDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    
    var body: some View {
        NavigationStack(path: $pathDataStore.albumViewNavigationPath) {
            BoolSwitchView(isEmpty: albumDataStore.albumArray.isEmpty, isLoading: albumDataStore.isLoading) {
                List(albumDataStore.albumArray) { album in
                    AlbumViewCell(album: album)
                }
                .listStyle(.plain)
                .scrollEdgeEffectStyle(.soft, for: .vertical)
            } emptyContent: {
                Text("AlbumView.emptyContent.Text")
            }
            .navigationTitle("AlbumView.navigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.AlbumViewPath.self) { path in
                destination(path: path)
            }
            .sheet(isPresented: $albumDataStore.isShowAddPlaylistView) {
                AddPlaylistView(music: albumDataStore.albumMusicArray.selected)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolBarMenu()
                }
            }
            .onAppear() {
                getAlbums()
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.AlbumViewPath) -> some View {
        switch path {
        case .albumMusic:
            AlbumMusicView()
        case .musicInfo:
            MusicInfoView(music: albumDataStore.albumMusicArray.selected)
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            ReloadButton {
                getAlbums()
            }
            Menu {
                Button {
                    AlbumRepository.sortAndUpdateAlbumSortMode(sortMode: .nameAscending)
                } label: {
                    Text("AlbumView.toolBarMenu.sort.nameAscending.Text")
                }
                Button {
                    AlbumRepository.sortAndUpdateAlbumSortMode(sortMode: .nameDescending)
                } label: {
                    Text("AlbumView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    AlbumRepository.sortAndUpdateAlbumSortMode(sortMode: .countAscending)
                } label: {
                    Text("AlbumView.toolBarMenu.sort.countAscending.Text")
                }
                Button {
                    AlbumRepository.sortAndUpdateAlbumSortMode(sortMode: .countDescending)
                } label: {
                    Text("AlbumView.toolBarMenu.sort.countDescending.Text")
                }
            } label: {
                Label("AlbumView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getAlbums() {
        Task {
            albumDataStore.isLoading = true
            albumDataStore.albumArray = await AlbumRepository.getAlbums()
            AlbumRepository.sortAlbumArray()
            albumDataStore.isLoading = false
        }
    }
}

#Preview {
    AlbumView()
}
