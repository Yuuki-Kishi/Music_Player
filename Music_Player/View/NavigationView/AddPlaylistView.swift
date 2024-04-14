//
//  AddPlaylistView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct AddPlaylistView: View {
    @State private var playlistArray = [PlaylistData]()
    @State private var isShowAlert = false
    @State private var isShowCreatePlaylist = false
    @State private var text = ""
    @Binding private var music: Music
    @Environment(\.presentationMode) var presentation
    
    init(music: Binding<Music>) {
        self._music = music
    }
    
    var body: some View {
        NavigationStack {
            List($playlistArray) { $playlist in
                HStack {
                    Text(playlist.playlistName)
                    Spacer()
                    Text(String(playlist.musicCount) + "曲")
                        .foregroundStyle(Color.gray)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    Task {
                        await PlaylistDataService.shared.addMusicToPlaylist(playlistId: playlist.playlistId, music: music)
                        isShowAlert = true
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("プレイリストに追加")
            .alert("追加完了", isPresented: $isShowAlert, actions: {
                Button("OK") {
                    isShowAlert = false
                    presentation.wrappedValue.dismiss()
                }
            }, message: {
                Text("プレイリストに追加しました。")
            })
            .navigationTitle("プレイリスト")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {isShowCreatePlaylist = true}, label: {
                        Image(systemName: "plus")
                    })
                })
            }
            .alert("プレイリストを追加", isPresented: $isShowCreatePlaylist, actions: {
                TextField("プレイリスト名", text: $text)
                Button("キャンセル", role: .cancel) {}
                Button("作成") {
                    Task {
                        let musics = [music]
                        await PlaylistDataService.shared.createPlaylistDataWithMusics(playlistName: text, musics: musics)
                        isShowCreatePlaylist = false
                        presentation.wrappedValue.dismiss()
                    }
                }
            }, message: {
                Text("新しく作成するプレイリストの名前を入力してください。曲は自動で追加されます。")
            })
        }
        .onAppear() {
            Task { playlistArray = await PlaylistDataService.shared.readPlaylistDatas() }
        }
    }
}
