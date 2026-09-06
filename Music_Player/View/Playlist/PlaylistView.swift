//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct PlaylistView: View {
    @EnvironmentObject private var playlistDataStore: PlaylistDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    @State private var isShowAlert: Bool = false
    @State private var newPlaylistNameText: String = ""
    
    var body: some View {
        NavigationStack(path: $pathDataStore.playlistViewNavigationPath) {
            VStack {
                BoolSwitchView(isEmpty: playlistDataStore.playlistArray.isEmpty, isLoading: playlistDataStore.isLoading) {
                    Text("\(String(playlistDataStore.playlistArray.count))PlaylistView.content.Text")
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    List(playlistDataStore.playlistArray) { playlist in
                        PlaylistViewCell(playlist: playlist)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                } emptyContent: {
                    Text("PlaylistView.emptyContent.Text")
                }
            }
            PlayWindowView()
            .navigationTitle("PlaylistView.navigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.PlaylistViewPath.self) { path in
                destination(path: path)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PlusButton {
                        isShowAlert = true
                    }
                }
                ToolbarSpacer()
                ToolbarItem(placement: .topBarTrailing) {
                    toolBarMenu()
                }
            }
            .alert("PlaylistView.Alert.title", isPresented: $isShowAlert) {
                alertActions()
            } message: {
                Text("PlaylistView.Alert.message")
            }
            .onAppear() {
                getPlaylists()
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.PlaylistViewPath) -> some View {
        switch path {
        case .playlistMusic:
            PlaylistMusicView()
        case .selectMusic:
            PlaylistSelectMusicView()
        case .musicInfo:
//            MusicInfoView(playGroup: .playlist)
            MusicInfoView(music: playlistDataStore.playlistMusicArray.selected)
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            ReloadButton {
                getPlaylists()
            }
            Menu {
                Button {
                    PlaylistRepository.sortAndUpdatePlaylistSortMode(sortMode: .nameAscending)
                } label: {
                    Text("PlaylistView.toolBarMenu.sort.nameAscending.Text")
                }
                Button{
                    PlaylistRepository.sortAndUpdatePlaylistSortMode(sortMode: .nameDescending)
                } label: {
                    Text("PlaylistView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    PlaylistRepository.sortAndUpdatePlaylistSortMode(sortMode: .countAscending)
                } label: {
                    Text("PlaylistView.toolBarMenu.sort.countAscending.Text")
                }
                Button {
                    PlaylistRepository.sortAndUpdatePlaylistSortMode(sortMode: .countDescending)
                } label: {
                    Text("PlaylistView.toolBarMenu.sort.countDescending.Text")
                }
            } label: {
                Label("PlaylistView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    @ViewBuilder
    func alertActions() -> some View {
        TextField("PlaylistView.Alert.textField", text: $newPlaylistNameText)
        CancelButton()
        Button {
            createPlaylist()
        } label: {
            Text("PlaylistView.AlertAction.createButton.Text")
        }
    }
    func getPlaylists() {
        playlistDataStore.isLoading = true
        playlistDataStore.playlistArray = PlaylistRepository.getPlaylists()
        PlaylistRepository.sortPlaylistArray()
        playlistDataStore.isLoading = false
    }
    func createPlaylist() {
        guard newPlaylistNameText != "" else { return }
        guard PlaylistRepository.createPlaylist(playlistName: newPlaylistNameText) else { return }
        getPlaylists()
    }
}

#Preview {
    PlaylistView()
}
