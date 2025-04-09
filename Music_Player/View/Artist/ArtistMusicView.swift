//
//  ArtistMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/24.
//

import SwiftUI

struct ArtistMusicView: View {
    @StateObject var artistDataStore = ArtistDataStore.shared
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
                                Text("すべて再生 (" + String(artistDataStore.artistMusicArray.count) + "曲)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                        })
                        .foregroundStyle(.primary)
                        List(artistDataStore.artistMusicArray) { music in
                            ArtistMusicViewCell(music: music)
                        }
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
            }, label: {
                Text("曲名昇順")
            })
            Button(action: {
                artistDataStore.artistMusicArraySort(mode: .nameDescending)
            }, label: {
                Text("曲名降順")
            })
            Button(action: {
                artistDataStore.artistMusicArraySort(mode: .dateAscending)
            }, label: {
                Text("更新日昇順")
            })
            Button(action: {
                artistDataStore.artistMusicArraySort(mode: .dateDescending)
            }, label: {
                Text("更新日降順")
            })
        } label: {
            Label("並び替え", systemImage: "arrow.up.arrow.down.circle")
        }
    }
    func getArtistMusics() {
        guard let artistName = artistDataStore.selectedArtist?.artistName else { return }
        Task {
            artistDataStore.artistMusicArray = await ArtistRepository.getArtistMusic(artistName: artistName)
            isLoading = false
        }
    }
    func randomPlay() {
        guard let music = artistDataStore.artistMusicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: artistDataStore.artistMusicArray.map { $0.filePath })
    }
}

#Preview {
    ArtistMusicView()
}
