//
//  PlaylistMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/18.
//

import SwiftUI
import SwiftData

struct PlaylistMusicView: View {
    @EnvironmentObject private var playlistDataStore: PlaylistDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    @State private var isShowRenameAlert: Bool = false
    @State private var isShowDeleteAlert: Bool = false
    @State private var renameText: String = ""
    
    var body: some View {
        VStack {
            BoolSwitchView(isEmpty: playlistDataStore.playlistMusicArray.isEmpty, isLoading: playlistDataStore.isLoading) {
                RandomPlayButton(dataStore: .playlist)
                List(playlistDataStore.playlistMusicArray) { music in
                    PlaylistMusicViewCell(music: music)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } emptyContent: {
                Text("PlaylistMusicView.emptyContent.Text")
            }
            PlayWindowView()
        }
        .navigationTitle(playlistDataStore.playlistArray.selected?.playlistName ?? String(localized: "PlaylistMusicView.navigationTitle.unknownPlaylistName"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolBarMenu()
            }
        }
        .alert("PlaylistMusicView.renameAlert.title", isPresented: $isShowRenameAlert) {
            renameAlertActions()
        } message: {
            Text("PlaylistMusicView.renameAlert.message")
        }
        .alert("\(playlistDataStore.playlistArray.selected?.playlistName ?? "PlaylistMusicView.deleteAlert.unknownPlaylistName")PlaylistMusicView.deleteAlert.title", isPresented: $isShowDeleteAlert) {
            deleteAlertActions()
        } message: {
            Text("PlaylistMusicView.deleteAlert.message")
        }
        .onAppear() {
            getPlaylistMusics()
        }
    }
    func toolBarMenu() -> some View{
        Menu {
            Button {
                pathDataStore.playlistViewNavigationPath.append(.selectMusic)
            } label: {
                Label("PlaylistMusicView.toolBarMenu.selectMusic.Label", systemImage: "pencil.and.list.clipboard")
            }
            Button {
                renameText = playlistDataStore.playlistArray.selected?.playlistName ?? ""
                isShowRenameAlert = true
            } label: {
                Label("PlaylistMusicView.toolBarMenu.renamePlaylist.Label", systemImage: "arrow.triangle.2.circlepath")
            }
            Menu {
                Button {
                    PlaylistRepository.sortAndUpdatePlaylistMusicSortMode(sortMode: .nameAscending)
                } label: {
                    Text("PlaylistMusicView.toolBarMenu.sort.nameAscending.Text")
                }
                Button{
                    PlaylistRepository.sortAndUpdatePlaylistMusicSortMode(sortMode: .nameDescending)
                } label: {
                    Text("PlaylistMusicView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    PlaylistRepository.sortAndUpdatePlaylistMusicSortMode(sortMode: .dateAscending)
                } label: {
                    Text("PlaylistMusicView.toolBarMenu.sort.dateAscending.Text")
                }
                Button {
                    PlaylistRepository.sortAndUpdatePlaylistMusicSortMode(sortMode: .dateDescending)
                } label: {
                    Text("PlaylistMusicView.toolBarMenu.sort.dateDescending.Text")
                }
            } label: {
                Label("PlaylistMusicView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down")
            }
            Divider()
            Button(role: .destructive) {
                isShowDeleteAlert = true
            } label: {
                Label("PlaylistMusicView.toolBarMenu.deleteButton.Label", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    @ViewBuilder
    func renameAlertActions() -> some View {
        TextField("PlaylistMusicView.renameAlertActions.TextField", text: $renameText)
        CancelButton()
        Button(role: .confirm) {
            guard let playlist = playlistDataStore.playlistArray.selected else { return }
            guard let newPlaylist = PlaylistRepository.renamePlaylist(playlist: playlist, newName: renameText) else { return }
            playlistDataStore.playlistArray.append(noDuplicate: newPlaylist)
            playlistDataStore.selectedPlaylistFilePath = newPlaylist.filePath
            playlistDataStore.playlistArray.remove(Playlist: playlist)
        } label: {
            Text("PlaylistMusicView.renameAlertAction.renameButton.Text")
        }
    }
    @ViewBuilder
    func deleteAlertActions() -> some View {
        CancelButton()
        DeleteButton {
            guard let playlist = playlistDataStore.playlistArray.selected else { return }
            guard PlaylistRepository.deletePlaylist(playlist: playlist) else { return }
            print("deleteSucceeded")
            pathDataStore.playlistViewNavigationPath.removeAll()
        }
    }
    func getPlaylistMusics() {
        Task {
            playlistDataStore.isLoading = true
            playlistDataStore.playlistMusicArray = await PlaylistRepository.getPlaylistMusic()
            PlaylistRepository.sortPlaylistMusicArray()
            playlistDataStore.isLoading = false
        }
    }
}

#Preview {
    PlaylistMusicView()
}
