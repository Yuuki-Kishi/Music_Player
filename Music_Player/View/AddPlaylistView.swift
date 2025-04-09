//
//  AddPlaylistView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct AddPlaylistView: View {
    @StateObject var pathDataStore = PathDataStore.shared
    @State private var playlistArray: [Playlist] = []
    @State private var isShowAddAlert = false
    @State private var isShowCreatePlaylist = false
    @State private var text = ""
    @State var music: Music
    @State var pathArray: PathArray
    
    enum PathArray {
        case music, artist, album, folder, play
    }
    
    var body: some View {
        List(playlistArray) { playlist in
            HStack {
                Text(playlist.playlistName)
                Spacer()
                Text(String(playlist.musicCount) + "曲")
                    .foregroundStyle(Color.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                tapped(playlist: playlist)
            }
        }
        .listStyle(.plain)
        .navigationTitle("プレイリストに追加")
        .alert("追加完了", isPresented: $isShowAddAlert, actions: {
            Button(action: {
                added()
            }, label: {
                Text("OK")
            })
        }, message: {
            Text("プレイリストに追加しました。")
        })
        .navigationTitle("プレイリスト")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    isShowCreatePlaylist = true
                }, label: {
                    Image(systemName: "plus")
                })
            })
        }
        .alert("プレイリストを追加", isPresented: $isShowCreatePlaylist, actions: {
            TextField("プレイリスト名", text: $text)
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(action: {
                createPlaylist()
            }, label: {
                Text("作成")
            })
        }, message: {
            Text("新しく作成するプレイリストの名前を入力してください。自動で追加されます。")
        })
        .onAppear() {
            playlistArray = PlaylistRepository.getPlaylists()
        }
    }
    func tapped(playlist: Playlist) {
        let playlist = PlaylistRepository.addPlaylistMusics(playlist: playlist, musicFilePaths: [music.filePath])
        isShowAddAlert = true
    }
    func createPlaylist() {
        if text != "" {
            guard PlaylistRepository.createPlaylist(playlistName: text) else { return }
            let playlist = Playlist(playlistName: text)
            let newPlaylist = PlaylistRepository.addPlaylistMusics(playlist: playlist, musicFilePaths: [music.filePath])
            isShowAddAlert = true
        }
    }
    func added() {
        switch pathArray {
        case .music:
            pathDataStore.musicViewNavigationPath.removeLast()
        case .artist:
            pathDataStore.artistViewNavigationPath.removeLast()
        case .album:
            pathDataStore.albumViewNavigationPath.removeLast()
        case .folder:
            pathDataStore.folderViewNavigationPath.removeLast()
        case .play:
            pathDataStore.playViewNavigationPath.removeLast()
        }
    }
}

#Preview {
    AddPlaylistView(music: Music(), pathArray: .music)
}
