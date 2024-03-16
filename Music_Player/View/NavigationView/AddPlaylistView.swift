//
//  AddPlaylistView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct AddPlaylistView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var playlistArray: [PlaylistData]
    @State private var isShowAlert = false
    @Binding private var music: Music
    
    init(music: Binding<Music>) {
        self._music = music
    }
    
    var body: some View {
        List(playlistArray) { playlist in
            HStack {
                Text(playlist.playlistName)
                Spacer()
                Text(String(playlist.musicCount) + "曲")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                addMusic(music: music, playlist: playlist)
                isShowAlert = true
            }
        }
        .listStyle(.plain)
        .navigationTitle("プレイリストに追加")
        .alert("追加完了", isPresented: $isShowAlert, actions: {
            Button("OK") {
                isShowAlert = false
            }
        }, message: {
            Text("プレイリストに追加しました。")
        })
    }
    func addMusic(music: Music, playlist: PlaylistData) {
        var musics = playlist.musics
        musics.append(music)
        let newPlaylist = PlaylistData(playlistName: playlist.playlistName, musicCount: playlist.musicCount + 1, musics: musics)
        modelContext.delete(playlist)
        modelContext.insert(newPlaylist)
    }
}
