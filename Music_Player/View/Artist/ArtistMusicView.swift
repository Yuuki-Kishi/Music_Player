//
//  ArtistMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/24.
//

import SwiftUI

struct ArtistMusicView: View {
    @ObservedObject var artistDataStore: ArtistDataStore
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var viewDataStore: ViewDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            VStack {
                if isLoading {
                    Spacer()
                    Text("読み込み中...")
                    Spacer()
                } else {
                    if artistDataStore.artistMusicArray.isEmpty {
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
                                Text("シャッフル再生 (" + String(artistDataStore.artistMusicArray.count) + "曲)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                        })
                        .foregroundStyle(.primary)
                        List(artistDataStore.artistMusicArray) { music in
                            ArtistMusicViewCell(artistDataStore: artistDataStore, playDataStore: playDataStore, pathDataStore: pathDataStore, music: music)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            VStack {
                Spacer()
                PlayWindowView(viewDataStore: viewDataStore, playDataStore: playDataStore)
            }
        }
        .navigationTitle(artistDataStore.selectedArtist?.artistName ?? "不明なアーティスト")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onAppear() {
            getArtistMusics()
        }
        .onDisappear() {
            artistDataStore.artistMusicArray.removeAll()
            isLoading = true
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                artistDataStore.artistMusicArraySort(mode: .nameAscending)
                artistDataStore.saveMusicSortMode()
            }, label: {
                Text("曲名昇順")
            })
            Button(action: {
                artistDataStore.artistMusicArraySort(mode: .nameDescending)
                artistDataStore.saveMusicSortMode()
            }, label: {
                Text("曲名降順")
            })
            Button(action: {
                artistDataStore.artistMusicArraySort(mode: .dateAscending)
                artistDataStore.saveMusicSortMode()
            }, label: {
                Text("更新日昇順")
            })
            Button(action: {
                artistDataStore.artistMusicArraySort(mode: .dateDescending)
                artistDataStore.saveMusicSortMode()
            }, label: {
                Text("更新日降順")
            })
        } label: {
            Label("並び替え", systemImage: "arrow.up.arrow.down")
        }
    }
    func getArtistMusics() {
        guard let artistName = artistDataStore.selectedArtist?.artistName else { return }
        Task {
            artistDataStore.artistMusicArray = await ArtistRepository.getArtistMusic(artistName: artistName)
            artistDataStore.loadMusicSort()
            isLoading = false
        }
    }
    func randomPlay() {
        guard let music = artistDataStore.artistMusicArray.randomElement() else { return }
        playDataStore.setPlayMode(playMode: .shuffle)
        playDataStore.musicChoosed(music: music, playGroup: .artist)
        playDataStore.setNextMusics(musicFilePaths: artistDataStore.artistMusicArray.map { $0.filePath })
    }
}

#Preview {
    ArtistMusicView(artistDataStore: ArtistDataStore.shared, playDataStore: PlayDataStore.shared, viewDataStore: ViewDataStore.shared, pathDataStore: PathDataStore.shared)
}
