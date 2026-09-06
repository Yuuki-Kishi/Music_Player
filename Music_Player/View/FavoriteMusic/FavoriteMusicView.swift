//
//  FavoriteMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct FavoriteMusicView: View {
    @EnvironmentObject private var favoriteMusicDataStore: FavoriteMusicDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    @State private var isShowAlert: Bool = false
    
    var body: some View {
        VStack {
            BoolSwitchView(isEmpty: favoriteMusicDataStore.favoriteMusicArray.isEmpty, isLoading: favoriteMusicDataStore.isLoading) {
                RandomPlayButton(dataStore: .favorite)
                List(favoriteMusicDataStore.favoriteMusicArray) { music in
                    FavoriteMusicViewCell(music: music)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } emptyContent: {
                Text("FavotiteMusicView.emptyContent.Text")
            }
            PlayWindowView()
        }
        .navigationTitle("FavoriteMusicView.navigationTitle")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolBarMenu()
            }
        }
        .alert("FavoriteMusicView.Alert.title", isPresented: $isShowAlert) {
            alertActions()
        } message: {
            Text("FavoriteMusicView.Alert.message")
        }
        .sheet(isPresented: $favoriteMusicDataStore.isShowAddPlaylistView) {
            AddPlaylistView(music: favoriteMusicDataStore.favoriteMusicArray.selected)
        }
        .onAppear() {
            if !FavoriteMusicRepository.isExistFavoriteMusicM3U8() {
                guard FavoriteMusicRepository.createFavoriteMusicM3U8() else { return }
                print("createSucceeded")
            }
            getFavoriteMusics()
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button {
                pathDataStore.musicViewNavigationPath.append(.selectFavoriteMusic)
            } label: {
                Label("FavoriteMusicView.toolBarMenu.selectFavoriteMusic.Label", systemImage: "pencil.and.list.clipboard")
            }
            Menu {
                Button {
                    FavoriteMusicRepository.sortAndUpdateFavoriteMusicSortMode(sortMode: .nameAscending)
                } label: {
                    Text("FavoriteMusicView.toolBarMenu.sort.nameAscending.Text")
                }
                Button {
                    FavoriteMusicRepository.sortAndUpdateFavoriteMusicSortMode(sortMode: .nameDescending)
                } label: {
                    Text("FavoriteMusicView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    FavoriteMusicRepository.sortAndUpdateFavoriteMusicSortMode(sortMode: .dateAscending)
                } label: {
                    Text("FavoriteMusicView.toolBarMenu.sort.dateAscending.Text")
                }
                Button {
                    FavoriteMusicRepository.sortAndUpdateFavoriteMusicSortMode(sortMode: .dateDescending)
                } label: {
                    Text("FavoriteMusicView.toolBarMenu.sort.dateDescending.Text")
                }
            } label: {
                Label("FavoriteMusicView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down.circle")
            }
            Divider()
            Button(role: .destructive) {
                isShowAlert = true
            } label: {
                Label("FavoriteMusicView.toolBarMenu.clean.Label", systemImage: "trash.fill")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    @ViewBuilder
    func alertActions() -> some View {
        CancelButton()
        Button(role: .destructive) {
            guard FavoriteMusicRepository.cleanUpFavorite() else { return }
            print("cleanUpSucceeded")
            favoriteMusicDataStore.favoriteMusicArray.removeAll()
        } label: {
            Text("FavoriteMusicView.AlertAction.cleanButton.Text")
        }
    }
    func getFavoriteMusics() {
        Task {
            favoriteMusicDataStore.isLoading = true
            favoriteMusicDataStore.favoriteMusicArray = await FavoriteMusicRepository.getFavoriteMusics()
            favoriteMusicDataStore.isLoading = false
        }
    }
}

#Preview {
    FavoriteMusicView()
}
