//
//  ArtistMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/24.
//

import SwiftUI

struct ArtistMusicView: View {
    @EnvironmentObject private var artistDataStore: ArtistDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    
    var body: some View {
        BoolSwitchView(isEmpty: artistDataStore.artistMusicArray.isEmpty, isLoading: artistDataStore.isLoading) {
            ZStack {
                List(artistDataStore.artistMusicArray) { music in
                    ArtistMusicViewCell(music: music)
                        .listRowInsets(.top, artistDataStore.artistMusicArray.first == music ? 65 : 11)
                        .listRowSeparator(artistDataStore.artistMusicArray.first == music ? .hidden : .visible, edges: .top)
                }
                .listStyle(.plain)
                .scrollEdgeEffectStyle(.soft, for: .vertical)
                RandomPlayButton(dataStore: .artist)
            }
        } emptyContent: {
            Text("ArtistMusicView.emptyContent.Text")
        }
        .navigationTitle(artistDataStore.artistArray.selected?.artistName ?? String(localized: "ArtistMusicView.navigationTitle.unknownArtistName"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolBarMenu()
            }
        }
        .onAppear() {
            getArtistMusics()
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            ReloadButton {
                getArtistMusics()
            }
            Menu {
                Button {
                    ArtistRepository.sortAndUpdateArtistMusicSortMode(sortMode: .nameAscending)
                } label: {
                    Text("ArtistMusicView.toolBarMenu.sort.nameAscending.Text")
                }
                Button {
                    ArtistRepository.sortAndUpdateArtistMusicSortMode(sortMode: .nameDescending)
                } label: {
                    Text("ArtistMusicView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    ArtistRepository.sortAndUpdateArtistMusicSortMode(sortMode: .dateAscending)
                } label: {
                    Text("ArtistMusicView.toolBarMenu.sort.dateAscending.Text")
                }
                Button {
                    ArtistRepository.sortAndUpdateArtistMusicSortMode(sortMode: .dateDescending)
                } label: {
                    Text("ArtistMusicView.toolBarMenu.sort.dateDescending.Text")
                }
            } label: {
                Label("ArtistMusicView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getArtistMusics() {
        Task {
            artistDataStore.isLoading = true
            artistDataStore.artistMusicArray = await ArtistRepository.getArtistMusic()
            ArtistRepository.sortArtistMusicArray()
            artistDataStore.isLoading = false
        }
    }
}

#Preview {
    ArtistMusicView()
}
