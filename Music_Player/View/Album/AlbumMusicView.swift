//
//  AlbumMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/24.
//

import SwiftUI

struct AlbumMusicView: View {
    @EnvironmentObject private var albumDataStore: AlbumDataStore
    
    var body: some View {
        BoolSwitchView(isEmpty: albumDataStore.albumMusicArray.isEmpty, isLoading: albumDataStore.isLoading) {
            ZStack {
                List(albumDataStore.albumMusicArray) { music in
                    AlbumMusicViewCell(music: music)
                        .listRowInsets(.top, albumDataStore.albumMusicArray.first == music ? 65 : 11)
                        .listRowSeparator(albumDataStore.albumMusicArray.first == music ? .hidden : .visible, edges: .top)
                }
                .listStyle(.plain)
                .scrollEdgeEffectStyle(.soft, for: .vertical)
                RandomPlayButton(dataStore: .album)
            }
        } emptyContent: {
            Text("AlbumMusicView.emptyContent.Text")
        }
        .navigationTitle(albumDataStore.albumArray.selected?.albumName ?? String(localized: "AlbumMusicView.navigationTitle.unknownAlbumName"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolBarMenu()
            }
        }
        .onAppear() {
            getAlbumMusics()
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            ReloadButton {
                getAlbumMusics()
            }
            Menu {
                Button {
                    AlbumRepository.sortAndUpdateAlbumMusicSortMode(sortMode: .nameAscending)
                } label: {
                    Text("AlbumMusicView.toolBarMenu.sort.nameAscending.Text")
                }
                Button {
                    AlbumRepository.sortAndUpdateAlbumMusicSortMode(sortMode: .nameDescending)
                } label: {
                    Text("AlbumMusicView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    AlbumRepository.sortAndUpdateAlbumMusicSortMode(sortMode: .dateAscending)
                } label: {
                    Text("AlbumMusicView.toolBarMenu.sort.dateAscending.Text")
                }
                Button {
                    AlbumRepository.sortAndUpdateAlbumMusicSortMode(sortMode: .dateDescending)
                } label: {
                    Text("AlbumMusicView.toolBarMenu.sort.dateDescending.Text")
                }
            } label: {
                Label("AlbumMusicView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getAlbumMusics() {
        Task {
            albumDataStore.isLoading = true
            albumDataStore.albumMusicArray = await AlbumRepository.getAlbumMusic()
            AlbumRepository.sortAlbumMusicArray()
            albumDataStore.isLoading = false
        }
    }
}

#Preview {
    AlbumMusicView()
}
