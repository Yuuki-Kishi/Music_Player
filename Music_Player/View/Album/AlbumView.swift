//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct AlbumView: View {
    @StateObject var albumDataStore = AlbumDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
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
                                AlbumViewCell(album: album)
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
            AlbumMusicView()
        case .addPlaylist:
            AddPlaylistView(music: albumDataStore.selectedMusic ?? Music(), pathArray: .album)
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
    AlbumView()
}
