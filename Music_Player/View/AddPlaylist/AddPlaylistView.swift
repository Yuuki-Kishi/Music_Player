//
//  AddPlaylistView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct AddPlaylistView: View {
    @EnvironmentObject private var addPlaylistDataStore: AddPlaylistDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    private let music: Music?
    @State private var isShowCreateAlert: Bool = false
    @State private var isShowAddedAlert: Bool = false
    @State private var text = ""
    @Environment(\.dismiss) private var dismiss
    
    init(music: Music?) {
        self.music = music
    }
    
    var body: some View {
        NavigationStack {
            BoolSwitchView(isEmpty: addPlaylistDataStore.playlistArray.isEmpty, isLoading: addPlaylistDataStore.isLoading) {
                List(addPlaylistDataStore.playlistArray) { playlist in
                    AddPlaylistViewCell(music: music, playlist: playlist)
                }
                .listStyle(.plain)
            } emptyContent: {
                Text("AddPlaylistView.emptyContent.Text")
            }
            .navigationTitle("AddPlaylistView.navigationTitle")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    PlusButton {
                        isShowCreateAlert = true
                    }
                }
            }
            .alert("AddPlaylistView.createAlert.title", isPresented: $isShowCreateAlert) {
                createAlertActions()
            } message: {
                Text("AddPlaylistView.createAlert.message")
            }
            .alert("\(text)AddPlaylistView.addedAlert.title", isPresented: $isShowAddedAlert) {
                OKButton {
                    dismiss()
                }
            } message: {
                Text("AddPlaylistView.addedAlert.message")
            }
            .onAppear() {
                onAppear()
            }
        }
    }
    @ViewBuilder
    func createAlertActions() -> some View {
        TextField("AddPlaylistView.createAlert.textField.title", text: $text)
        CancelButton()
        Button {
            createPlaylist()
        } label: {
            Text("AddPlaylistView.createAlert.button.Text")
        }
    }
    func createPlaylist() {
        guard text != "" else { return }
        guard PlaylistRepository.createPlaylist(playlistName: text) else { return }
        guard let filePath = music?.filePath else { return }
        guard PlaylistRepository.addPlaylistMusic(playlistFilePath: "Playlist/\(text).m3u8", musicFilePath: filePath) else { return }
        isShowAddedAlert = true
    }
    func onAppear() {
        addPlaylistDataStore.isLoading = true
        addPlaylistDataStore.playlistArray = PlaylistRepository.getPlaylists()
        addPlaylistDataStore.isLoading = false
    }
}

#Preview {
    AddPlaylistView(music: Music())
}
