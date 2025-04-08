//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct PlaylistView: View {
    @StateObject var playlistDataStore = PlaylistDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State private var isShowAlert = false
    @State private var text = ""
    
    var body: some View {
        NavigationStack(path: $pathDataStore.playlistViewNavigationPath) {
            VStack {
                if playlistDataStore.playlistArray.isEmpty {
                    Spacer()
                    Text("表示できるプレイリストがありません")
                    Spacer()
                } else {
                    Text(String(playlistDataStore.playlistArray.count) + "個のプレイリスト")
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    List(playlistDataStore.playlistArray) { playlist in
                        PlaylistViewCell(playlist: playlist)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                PlayWindowView()
            }
            .navigationTitle("プレイリスト")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .navigationDestination(for: PathDataStore.PlaylistViewPath.self) { path in
                destination(path: path)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        isShowAlert = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                })
            }
            .alert("プレイリストを作成", isPresented: $isShowAlert, actions: {
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
                Text("作成するプレイリストの名前を入力してください。")
            })
        }
        .onAppear() {
            Task {
                playlistDataStore.playlistArray = await PlaylistRepository.getPlaylists()
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
            MusicInfoView(music: playlistDataStore.selectedMusic ?? Music())
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                playlistDataStore.playlistArraySort(mode: .nameAscending)
            }, label: {
                Text("プレイリスト名昇順")
            })
            Button(action: {
                playlistDataStore.playlistArraySort(mode: .nameDescending)
            }, label: {
                Text("プレイリスト名降順")
            })
            Button(action: {
                playlistDataStore.playlistArraySort(mode: .countAscending)
            }, label: {
                Text("曲数昇順")
            })
            Button(action: {
                playlistDataStore.playlistArraySort(mode: .countDescending)
            }, label: {
                Text("曲数降順")
            })
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
    func createPlaylist() {
        if text != "" {
            Task {
                guard await PlaylistRepository.createPlaylist(playlistName: text) else { return }
                playlistDataStore.playlistArray = await PlaylistRepository.getPlaylists()
            }
        }
    }
}

#Preview {
    PlaylistView()
}
