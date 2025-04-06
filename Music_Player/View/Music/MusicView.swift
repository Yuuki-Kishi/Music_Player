//
//  Music.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI
import SwiftData

struct MusicView: View {
    @StateObject var musicDataStore = MusicDataStore.shared
    @StateObject var playDataStore = PlayDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    
    var body: some View {
        NavigationStack(path: $pathDataStore.musicViewNavigationPath) {
            ZStack {
                VStack {
                    if musicDataStore.musicArray.isEmpty {
                        Text("表示できる曲がありません")
                    } else {
                        Button(action: {
                            randomPlay()
                        }, label: {
                            HStack {
                                Image(systemName: "play.circle")
                                    .foregroundStyle(.accent)
                                Text("すべて再生 (" + String(musicDataStore.musicArray.count) + "曲)")
                            }
                        })
                        List(musicDataStore.musicArray) { music in
                            MusicCellView(music: music)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                    PlayWindowView()
                }
                .padding(.horizontal)
                LoadingView()
            }
            .navigationTitle("ミュージック")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.MusicViewPath.self) { path in
                destination(path: path)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    toolBarMenu()
                })
            }
            .onAppear() {
                pathDataStore.musicViewNavigationPath.removeAll()
                Task {
                    musicDataStore.musicArray = await MusicRepository.getMusics()
                }
            }
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                
            }, label: {
                Label("設定", systemImage: "gearshape")
            })
            Button(action: {
                pathDataStore.musicViewNavigationPath.append(.sleepTImer)
            }, label: {
                Label("スリープタイマー", systemImage: "timer")
            })
            Menu {
                Button(action: {
                    musicDataStore.arraySort(mode: .nameAscending)
                }, label: {
                    Text("曲名昇順")
                })
                Button(action: {
                    musicDataStore.arraySort(mode: .nameDescending)
                }, label: {
                    Text("曲名降順")
                })
                Button(action: {
                    musicDataStore.arraySort(mode: .dateAscending)
                }, label: {
                    Text("更新日昇順")
                })
                Button(action: {
                    musicDataStore.arraySort(mode: .dateDescending)
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
    @ViewBuilder
    func destination(path: PathDataStore.MusicViewPath) -> some View {
        switch path {
        case .addPlaylist:
            AddPlaylistView(music: musicDataStore.selectedMusic ?? Music(), pathArray: .music)
        case .musicInfo:
            MusicInfoView(music: musicDataStore.selectedMusic ?? Music())
        case .favoriteMusic:
            FavoriteMusicView()
        case .selectFavoriteMusic:
            FavoriteMusicSelectView()
        case .setting:
            EmptyView()
        case .sleepTImer:
            SleepTimer()
        }
    }
    func randomPlay() {
        guard let music = musicDataStore.musicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: musicDataStore.musicArray.map { $0.filePath })
    }
}

#Preview {
    MusicView()
}

