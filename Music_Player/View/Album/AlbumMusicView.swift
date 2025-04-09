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
    
    var body: some View {
        VStack {
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
                        Text("すべて再生 (" + String(albumDataStore.albumMusicArray.count) + "曲)")
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
            PlayWindowView()
        }
        .navigationTitle(albumDataStore.selectedAlbum?.albumName ?? "不明なアルバム")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .padding(.horizontal)
        .onAppear() {
            getAlbumMusics()
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                albumDataStore.albumMusicArraySort(mode: .nameAscending)
            }, label: {
                Text("曲名昇順")
            })
            Button(action: {
                albumDataStore.albumMusicArraySort(mode: .nameDescending)
            }, label: {
                Text("曲名降順")
            })
            Button(action: {
                albumDataStore.albumMusicArraySort(mode: .dateAscending)
            }, label: {
                Text("更新日昇順")
            })
            Button(action: {
                albumDataStore.albumMusicArraySort(mode: .dateDescending)
            }, label: {
                Text("更新日降順")
            })
        } label: {
            Label("並び替え", systemImage: "arrow.up.arrow.down.circle")
        }
    }
    func getAlbumMusics() {
        guard let albumName = albumDataStore.selectedAlbum?.albumName else { return }
        Task {
            albumDataStore.albumMusicArray = await AlbumRepository.getAlbumMusic(albumName: albumName)
        }
    }
    func randomPlay() {
        guard let music = albumDataStore.albumMusicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: albumDataStore.albumMusicArray.map { $0.filePath })
    }
}

#Preview {
    AlbumMusicView()
}
