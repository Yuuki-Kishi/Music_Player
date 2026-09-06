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
        VStack {
            BoolSwitchView(isEmpty: artistDataStore.artistMusicArray.isEmpty, isLoading: artistDataStore.isLoading) {
                RandomPlayButton(dataStore: .artist)
                List(artistDataStore.artistMusicArray) { music in
                    ArtistMusicViewCell(music: music)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } emptyContent: {
                Text("ArtistMusicView.emptyContent.Text")
            }
            PlayWindowView()
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
