//
//  PlaylistMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/18.
//

import SwiftUI
import SwiftData

struct PlaylistMusicView: View {
    @StateObject var playlistDataStore = PlaylistDataStore.shared
    @StateObject var playDataStore = PlayDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State private var isShowRenameAlert: Bool = false
    @State private var isShowDeleteAlert: Bool = false
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            if playlistDataStore.playlistMusicArray.isEmpty {
                Spacer()
                Text("表示できる曲がありません")
                Spacer()
            } else {
                Button(action: {
                    randomPlay()
                }, label: {
                    HStack {
                        Image(systemName: "play.circle")
                            .foregroundStyle(.accent)
                        Text("すべて再生 (" + String(playlistDataStore.playlistMusicArray.count) + "曲)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                })
                .foregroundStyle(.primary)
                List(playlistDataStore.playlistMusicArray) { music in
                    PlaylistMusicViewCell(music: music)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            PlayWindowView()
        }
        .navigationTitle(playlistDataStore.selectedPlaylist?.playlistName ?? "不明なプレイリスト")
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .alert("プレイリスト名の変更", isPresented: $isShowRenameAlert, actions: {
            TextField("新しい名前", text: $text)
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(action: {
                renamePlaylist()
            }, label: {
                Text("変更")
            })
        }, message: {
            Text("プレイリストの新しい名前を入力してください。")
        })
        .alert("本当に削除しますか？", isPresented: $isShowDeleteAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                deletePlaylist()
            }, label: {
                Text("削除")
            })
        }, message: {
            Text("作成するプレイリストの名前を入力してください。")
        })
        .onAppear() {
            getPlaylistMusics()
        }
    }
    func toolBarMenu() -> some View{
        Menu {
            Button(action: {
                pathDataStore.playlistViewNavigationPath.append(.selectMusic)
            }, label: {
                Label("曲を追加", systemImage: "plus")
            })
            Button(action: {
                text = playlistDataStore.selectedPlaylist?.playlistName ?? ""
                isShowRenameAlert = true
            }, label: {
                Label("名前を変更する", systemImage: "arrow.triangle.2.circlepath")
            })
            Menu {
                Button(action: {
                    playlistDataStore.playlistMusicArraySort(mode: .nameAscending)
                }, label: {
                    Text("曲名昇順")
                })
                Button(action: {
                    playlistDataStore.playlistMusicArraySort(mode: .nameDescending)
                }, label: {
                    Text("曲名降順")
                })
                Button(action: {
                    playlistDataStore.playlistMusicArraySort(mode: .dateAscending)
                }, label: {
                    Text("更新日昇順")
                })
                Button(action: {
                    playlistDataStore.playlistMusicArraySort(mode: .dateDescending)
                }, label: {
                    Text("更新日降順")
                })
            } label: {
                Label("並び替え", systemImage: "arrow.up.arrow.down")
            }
            Divider()
            Button(role: .destructive, action: {
                isShowDeleteAlert = true
            }, label: {
                Label("プレイリストを削除", systemImage: "trash")
            })
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getPlaylistMusics() {
        Task {
            guard let filePath = playlistDataStore.selectedPlaylist?.filePath else { return }
            playlistDataStore.playlistMusicArray = await PlaylistRepository.getPlaylistMusic(filePath: filePath)
        }
    }
    func randomPlay() {
        guard let music = playlistDataStore.playlistMusicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: playlistDataStore.playlistMusicArray.map { $0.filePath })
    }
    func renamePlaylist() {
        if text != "" {
            guard let playlist = playlistDataStore.selectedPlaylist else { return }
            guard PlaylistRepository.renamePlaylist(playlist: playlist, newName: text) else { return }
            getPlaylistMusics()
        }
    }
    func deletePlaylist() {
        guard let playlist = playlistDataStore.selectedPlaylist else { return }
        guard PlaylistRepository.deletePlaylist(playlist: playlist) else { return }
        pathDataStore.playlistViewNavigationPath.removeLast()
    }
}

#Preview {
    PlaylistMusicView()
}
