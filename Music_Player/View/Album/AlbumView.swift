//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct AlbumView: View {
    @StateObject var albumDataStore = AlbumDataStore.shared
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var viewDataStore: ViewDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack(path: $pathDataStore.albumViewNavigationPath) {
            ZStack {
                VStack {
                    if isLoading {
                        Spacer()
                        Text("読み込み中...")
                        Spacer()
                    } else {
                        if albumDataStore.albumArray.isEmpty {
                            Spacer()
                            Text("表示できるアルバムがありません")
                            Spacer()
                        } else {
                            Text(String(albumDataStore.albumArray.count) + "個のアルバム")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            List(albumDataStore.albumArray) { album in
                                AlbumViewCell(albumDataStore: albumDataStore, pathDataStore: pathDataStore, album: album)
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
            .navigationTitle("アルバム")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.AlbumViewPath.self) { path in
                destination(path: path)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    toolBarMenu()
                })
            }
            .onAppear() {
                getAlbums()
            }
            .onDisappear() {
                isLoading = true
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.AlbumViewPath) -> some View {
        switch path {
        case .albumMusic:
            AlbumMusicView(albumDataStore: albumDataStore, playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
        case .addPlaylist:
            AddPlaylistView(pathDataStore: pathDataStore, music: albumDataStore.selectedMusic ?? Music(), pathArray: .album)
        case .musicInfo:
            MusicInfoView(music: albumDataStore.selectedMusic ?? Music())
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                albumDataStore.albumArraySort(mode: .nameAscending)
                albumDataStore.saveSortMode()
            }, label: {
                Text("アルバム名昇順")
            })
            Button(action: {
                albumDataStore.albumArraySort(mode: .nameDescending)
                albumDataStore.saveSortMode()
            }, label: {
                Text("アルバム名降順")
            })
            Button(action: {
                albumDataStore.albumArraySort(mode: .countAscending)
                albumDataStore.saveSortMode()
            }, label: {
                Text("曲数昇順")
            })
            Button(action: {
                albumDataStore.albumArraySort(mode: .countDescending)
                albumDataStore.saveSortMode()
            }, label: {
                Text("曲数降順")
            })
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
    func getAlbums() {
        Task {
            albumDataStore.albumArray = await AlbumRepository.getAlbums()
            albumDataStore.loadSort()
            isLoading = false
        }
    }
}

#Preview {
    AlbumView(albumDataStore: AlbumDataStore.shared, playDataStore: PlayDataStore.shared, viewDataStore: ViewDataStore.shared, pathDataStore: PathDataStore.shared)
}
