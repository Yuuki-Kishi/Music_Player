//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ArtistView: View {
    @EnvironmentObject private var artistDataStore: ArtistDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    
    var body: some View {
        NavigationStack(path: $pathDataStore.artistViewNavigationPath) {
            VStack {
                BoolSwitchView(isEmpty: artistDataStore.artistArray.isEmpty, isLoading: artistDataStore.isLoading) {
                    Text("\(String(artistDataStore.artistArray.count))ArtistView.content.Text")
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    List(artistDataStore.artistArray) { artist in
                        ArtistViewCell(artist: artist)
                    }
                    .listStyle(.plain)
                } emptyContent: {
                    Text("ArtistView.emptyContent.Text")
                }
                PlayWindowView()
            }
            .navigationTitle("ArtistView.navigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.ArtistViewPath.self) { path in
                destination(path: path)
            }
            .sheet(isPresented: $artistDataStore.isShowAddPlaylistView) {
                AddPlaylistView(music: artistDataStore.artistMusicArray.selected)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolBarMenu()
                }
            }
            .onAppear() {
                getArtists()
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.ArtistViewPath) -> some View {
        switch path {
        case .artistMusic:
            ArtistMusicView()
        case .musicInfo:
//            MusicInfoView(playGroup: .artist)
            MusicInfoView(music: artistDataStore.artistMusicArray.selected)
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            ReloadButton {
                getArtists()
            }
            Menu {
                Button {
                    ArtistRepository.sortAndUpdateArtistSortMode(sortMode: .nameAscending)
                } label: {
                    Text("ArtistView.toolBarMenu.sort.nameAscending.Text")
                }
                Button {
                    ArtistRepository.sortAndUpdateArtistSortMode(sortMode: .nameDescending)
                } label: {
                    Text("ArtistView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    ArtistRepository.sortAndUpdateArtistSortMode(sortMode: .countAscending)
                } label: {
                    Text("ArtistView.toolBarMenu.sort.countAscending.Text")
                }
                Button {
                    ArtistRepository.sortAndUpdateArtistSortMode(sortMode: .countDescending)
                } label: {
                    Text("ArtistView.toolBarMenu.sort.countDescending.Text")
                }
            } label: {
                Label("ArtistView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getArtists() {
        Task {
            artistDataStore.isLoading = true
            artistDataStore.artistArray = await ArtistRepository.getArtists()
            ArtistRepository.sortArtistArray()
            artistDataStore.isLoading = false
        }
    }
}

#Preview {
    ArtistView()
}
