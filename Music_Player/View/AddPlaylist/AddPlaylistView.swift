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
    @State private var isLoading: Bool = true
    @State private var isShowCleateAlert: Bool = false
    @State private var isShowAddedAlert: Bool = false
    @State private var text = ""
    @State var music: Music
    @State var pathArray: PathArray
    
    enum PathArray {
        case music, artist, album, folder, play
    }
    
    var body: some View {
        ZStack {
            if isLoading {
                Spacer()
                Text("読み込み中...")
                Spacer()
            } else {
                if playlistArray.isEmpty {
                    Spacer()
                    Text("表示できるプレイリストがありません")
                    Spacer()
                } else {
                    List(playlistArray) { playlist in
                        AddPlaylistViewCell(playlist: playlist, music: music, pathArray: pathArray)
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle("プレイリストに追加")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    isShowCleateAlert = true
                }, label: {
                    Image(systemName: "plus")
                })
            })
        }
        .alert("プレイリストを追加", isPresented: $isShowCleateAlert, actions: {
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
        .alert("追加完了", isPresented: $isShowAddedAlert, actions: {
            Button(action: {
                added()
            }, label: {
                Text("OK")
            })
        }, message: {
            Text("プレイリストに追加しました。")
        })
        .onAppear() {
            playlistArray = PlaylistRepository.getPlaylists()
            isLoading = false
        }
    }
    func createPlaylist() {
        if text != "" {
            guard PlaylistRepository.createPlaylist(playlistName: text) else { return }
            guard PlaylistRepository.addPlaylistMusic(playlistFilePath: "Playlist/\(text).m3u8", musicFilePath: music.filePath) else { return }
            isShowAddedAlert = true
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
