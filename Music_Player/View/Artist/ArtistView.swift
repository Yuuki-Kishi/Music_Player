//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct ArtistView: View {
    @StateObject var artistDataStore = ArtistDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    
    var body: some View {
        NavigationStack(path: $pathDataStore.artistViewNavigationPath) {
            VStack {
                if artistDataStore.artistArray.isEmpty {
                    Spacer()
                    Text("表示できるアーティストがいません")
                    Spacer()
                } else {
                    Text(String(artistDataStore.artistArray.count) + "人のアーティスト")
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    List(artistDataStore.artistArray) { artist in
                        ArtistViewCell(artist: artist)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                PlayWindowView()
            }
            .navigationTitle("アーティスト")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .navigationDestination(for: PathDataStore.ArtistViewPath.self) { path in
                destination(path: path)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    toolBarMenu()
                })
            }
        }
        .onAppear() {
            getArtists()
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.ArtistViewPath) -> some View {
        switch path {
        case .artistMusic:
            ArtistMusicView()
        case .addPlaylist:
            AddPlaylistView(music: artistDataStore.selectedMusic ?? Music(), pathArray: .artist)
        case .musicInfo:
            MusicInfoView(music: artistDataStore.selectedMusic ?? Music())
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                artistDataStore.artistArraySort(mode: .nameAscending)
            }, label: {
                Text("アーティスト名昇順")
            })
            Button(action: {
                artistDataStore.artistArraySort(mode: .nameDescending)
            }, label: {
                Text("アーティスト名降順")
            })
            Button(action: {
                artistDataStore.artistArraySort(mode: .countAscending)
            }, label: {
                Text("曲数昇順")
            })
            Button(action: {
                artistDataStore.artistArraySort(mode: .countDescending)
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
        }
    }
}

#Preview {
    ArtistView()
}
