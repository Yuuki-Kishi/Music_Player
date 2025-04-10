//
//  AlbumMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/24.
//

import SwiftUI

struct AlbumMusicView: View {
    @StateObject var albumDataStore = AlbumDataStore.shared
    @StateObject var playDataStore = PlayDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
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
                            AlbumMusicViewCell(music: music)
                        }
                        .frame(maxHeight: .infinity)
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            VStack {
                Spacer()
                PlayWindowView()
            }
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
    }
    func getAlbumMusics() {
        guard let albumName = albumDataStore.selectedAlbum?.albumName else { return }
        Task {
            albumDataStore.albumMusicArray = await AlbumRepository.getAlbumMusic(albumName: albumName)
            albumDataStore.loadMusicSort()
            isLoading = false
        }
    }
    func randomPlay() {
        guard let music = albumDataStore.albumMusicArray.randomElement() else { return }
        playDataStore.setPlayMode(playMode: .shuffle)
        playDataStore.musicChoosed(music: music, playGroup: .album)
        playDataStore.setNextMusics(musicFilePaths: albumDataStore.albumMusicArray.map { $0.filePath })
    }
}

#Preview {
    AlbumMusicView()
}
