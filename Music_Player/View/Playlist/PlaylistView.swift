//
//  PlayList.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct PlaylistView: View {
    @StateObject var playlistDataStore = PlaylistDataStore.shared
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var viewDataStore: ViewDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isLoading: Bool = true
    @State private var isShowAlert = false
    @State private var text = ""
    
    var body: some View {
        NavigationStack(path: $pathDataStore.playlistViewNavigationPath) {
            ZStack {
                if isLoading {
                    Spacer()
                    Text("読み込み中...")
                    Spacer()
                } else {
                    VStack {
                        if playlistDataStore.playlistArray.isEmpty {
                            Spacer()
                            Text("表示できるプレイリストがありません")
                            Spacer()
                        } else {
                            Text(String(playlistDataStore.playlistArray.count) + "個のプレイリスト")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            List(playlistDataStore.playlistArray) { playlist in
                                PlaylistViewCell(playlistDataStore: playlistDataStore, pathDataStore: pathDataStore, playlist: playlist)
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                        }
                        PlayWindowView(viewDataStore: viewDataStore, playDataStore: playDataStore)
                    }
                }
            }
            .navigationTitle("プレイリスト")
            .navigationBarTitleDisplayMode(.inline)
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
            .onAppear() {
                getPlaylists()
            }
            .onDisappear() {
                isLoading = true
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.PlaylistViewPath) -> some View {
        switch path {
        case .playlistMusic:
            PlaylistMusicView(playlistDataStore: playlistDataStore, playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
        case .selectMusic:
            PlaylistSelectMusicView(playlistDataStore: playlistDataStore, pathDataStore: pathDataStore)
        case .musicInfo:
            MusicInfoView(music: playlistDataStore.selectedMusic ?? Music())
        }
    }
    func getPlaylists() {
        playlistDataStore.playlistArray = PlaylistRepository.getPlaylists()
        playlistDataStore.loadSort()
        isLoading = false
    }
    func createPlaylist() {
        if text != "" {
            guard PlaylistRepository.createPlaylist(playlistName: text) else { return }
            getPlaylists()
        }
    }
}

#Preview {
    PlaylistView(playlistDataStore: PlaylistDataStore.shared, playDataStore: PlayDataStore.shared, viewDataStore: ViewDataStore.shared, pathDataStore: PathDataStore.shared)
}
