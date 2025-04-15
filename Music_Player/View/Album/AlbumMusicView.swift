//
//  AlbumMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/24.
//

import SwiftUI

struct AlbumMusicView: View {
    @ObservedObject var albumDataStore: AlbumDataStore
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var viewDataStore: ViewDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                Text("読み込み中...")
                Spacer()
            } else {
                if albumDataStore.albumMusicArray.isEmpty {
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
                            Text("シャッフル再生 (" + String(albumDataStore.albumMusicArray.count) + "曲)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal)
                    })
                    .foregroundStyle(.primary)
                    List(albumDataStore.albumMusicArray) { music in
                        AlbumMusicViewCell(albumDataStore: albumDataStore, playDataStore: playDataStore, pathDataStore: pathDataStore, music: music)
                    }
                    .frame(maxHeight: .infinity)
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            PlayWindowView(viewDataStore: viewDataStore, playDataStore: playDataStore)
        }
        .navigationTitle(albumDataStore.selectedAlbum?.albumName ?? "不明なアルバム")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onAppear() {
            getAlbumMusics()
        }
        .onDisappear() {
            isLoading = true
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                reloadData()
            }, label: {
                Label("再読み込み", systemImage: "arrow.clockwise")
            })
            Menu {
                Button(action: {
                    albumDataStore.albumMusicArraySort(mode: .nameAscending)
                    albumDataStore.saveMusicSortMode()
                }, label: {
                    Text("曲名昇順")
                })
                Button(action: {
                    albumDataStore.albumMusicArraySort(mode: .nameDescending)
                    albumDataStore.saveMusicSortMode()
                }, label: {
                    Text("曲名降順")
                })
                Button(action: {
                    albumDataStore.albumMusicArraySort(mode: .dateAscending)
                    albumDataStore.saveMusicSortMode()
                }, label: {
                    Text("更新日昇順")
                })
                Button(action: {
                    albumDataStore.albumMusicArraySort(mode: .dateDescending)
                    albumDataStore.saveMusicSortMode()
                }, label: {
                    Text("更新日降順")
                })
            } label: {
                Label("並び替え", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getAlbumMusics() {
        Task {
            guard let albumName = albumDataStore.selectedAlbum?.albumName else { return }
            albumDataStore.albumMusicArray = await AlbumRepository.getAlbumMusic(albumName: albumName)
            albumDataStore.loadMusicSort()
            isLoading = false
        }
    }
    func reloadData() {
        isLoading = true
        getAlbumMusics()
    }
    func randomPlay() {
        guard let music = albumDataStore.albumMusicArray.randomElement() else { return }
        playDataStore.setPlayMode(playMode: .shuffle)
        playDataStore.musicChoosed(music: music, playGroup: .album)
        playDataStore.setNextMusics(musicFilePaths: albumDataStore.albumMusicArray.map { $0.filePath })
    }
}

#Preview {
    AlbumMusicView(albumDataStore: AlbumDataStore.shared, playDataStore: PlayDataStore.shared, viewDataStore: ViewDataStore.shared, pathDataStore: PathDataStore.shared)
}
