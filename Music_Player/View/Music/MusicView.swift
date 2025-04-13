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
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var viewDataStore: ViewDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack(path: $pathDataStore.musicViewNavigationPath) {
            ZStack {
                VStack {
                    if isLoading {
                        Spacer()
                        Text("読み込み中...")
                        Spacer()
                    } else {
                        if musicDataStore.musicArray.isEmpty {
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
                                    Text("シャッフル再生 (" + String(musicDataStore.musicArray.count) + "曲)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal)
                            })
                            .foregroundStyle(.primary)
                            List(musicDataStore.musicArray) { music in
                                MusicCellView(musicDataStore: musicDataStore, playDataStore: playDataStore, pathDataStore: pathDataStore, music: music)
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
                getMusics()
            }
            .onDisappear() {
                isLoading = true
            }
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                isLoading = true
                getMusics()
            }, label: {
                Label("ファイルをスキャン", systemImage: "document.viewfinder.fill")
            })
            Button(action: {
                pathDataStore.musicViewNavigationPath.append(.favoriteMusic)
            }, label: {
                Label("お気に入り", systemImage: "heart.fill")
            })
            Button(action: {
                pathDataStore.musicViewNavigationPath.append(.equalizer)
            }, label: {
                Label("イコライザ", systemImage: "slider.vertical.3")
            })
            Button(action: {
                pathDataStore.musicViewNavigationPath.append(.sleepTImer)
            }, label: {
                Label("スリープタイマー", systemImage: "timer")
            })
            Menu {
                Button(action: {
                    musicDataStore.arraySort(mode: .nameAscending)
                    musicDataStore.saveSortMode()
                }, label: {
                    Text("曲名昇順")
                })
                Button(action: {
                    musicDataStore.arraySort(mode: .nameDescending)
                    musicDataStore.saveSortMode()
                }, label: {
                    Text("曲名降順")
                })
                Button(action: {
                    musicDataStore.arraySort(mode: .dateAscending)
                    musicDataStore.saveSortMode()
                }, label: {
                    Text("更新日昇順")
                })
                Button(action: {
                    musicDataStore.arraySort(mode: .dateDescending)
                    musicDataStore.saveSortMode()
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
            AddPlaylistView(pathDataStore: pathDataStore, music: musicDataStore.selectedMusic ?? Music(), pathArray: .music)
        case .musicInfo:
            MusicInfoView(music: musicDataStore.selectedMusic ?? Music())
        case .favoriteMusic:
            FavoriteMusicView(playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
        case .selectFavoriteMusic:
            FavoriteMusicSelectView(pathDataStore: pathDataStore)
        case .equalizer:
            EqualizerView(playDataStore: playDataStore, pathDataStore: pathDataStore)
        case .setting:
            EmptyView()
        case .sleepTImer:
            SleepTimer(viewDataStore: viewDataStore)
        }
    }
    func getMusics() {
        Task {
            musicDataStore.musicArray = await MusicRepository.getMusics()
            musicDataStore.loadSort()
            isLoading = false
        }
    }
    func randomPlay() {
        guard let music = musicDataStore.musicArray.randomElement() else { return }
        playDataStore.setPlayMode(playMode: .shuffle)
        playDataStore.musicChoosed(music: music, playGroup: .music)
        playDataStore.setNextMusics(musicFilePaths: musicDataStore.musicArray.map { $0.filePath })
    }
}

#Preview {
    MusicView(playDataStore: PlayDataStore.shared, viewDataStore: ViewDataStore.shared, pathDataStore: PathDataStore.shared)
}

