//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ArtistView: View {
    @StateObject var artistDataStore = ArtistDataStore.shared
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var viewDataStore: ViewDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack(path: $pathDataStore.artistViewNavigationPath) {
            ZStack {
                VStack {
                    if isLoading {
                        Spacer()
                        Text("読み込み中...")
                        Spacer()
                    } else {
                        if artistDataStore.artistArray.isEmpty {
                            Spacer()
                            Text("表示できるアーティストがいません")
                            Spacer()
                        } else {
                            Text(String(artistDataStore.artistArray.count) + "人のアーティスト")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            List(artistDataStore.artistArray) { artist in
                                ArtistViewCell(artistDataStore: artistDataStore, pathDataStore: pathDataStore, artist: artist)
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
            .navigationTitle("アーティスト")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.ArtistViewPath.self) { path in
                destination(path: path)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    toolBarMenu()
                })
            }
            .onAppear() {
                getArtists()
            }
            .onDisappear() {
                isLoading = true
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.ArtistViewPath) -> some View {
        switch path {
        case .artistMusic:
            ArtistMusicView(artistDataStore: artistDataStore, playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
        case .addPlaylist:
            AddPlaylistView(pathDataStore: pathDataStore, music: artistDataStore.selectedMusic ?? Music(), pathArray: .artist)
        case .musicInfo:
            MusicInfoView(music: artistDataStore.selectedMusic ?? Music())
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                artistDataStore.artistArraySort(mode: .nameAscending)
                artistDataStore.saveSortMode()
            }, label: {
                Text("アーティスト名昇順")
            })
            Button(action: {
                artistDataStore.artistArraySort(mode: .nameDescending)
                artistDataStore.saveSortMode()
            }, label: {
                Text("アーティスト名降順")
            })
            Button(action: {
                artistDataStore.artistArraySort(mode: .countAscending)
                artistDataStore.saveSortMode()
            }, label: {
                Text("曲数昇順")
            })
            Button(action: {
                artistDataStore.artistArraySort(mode: .countDescending)
                artistDataStore.saveSortMode()
            }, label: {
                Text("曲数降順")
            })
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
    func getArtists() {
        Task {
            artistDataStore.artistArray = await ArtistRepository.getArtists()
            artistDataStore.loadSort()
            isLoading = false
        }
    }
}

#Preview {
    ArtistView(playDataStore: PlayDataStore.shared, viewDataStore: ViewDataStore.shared, pathDataStore: PathDataStore.shared)
}
