//
//  FavoriteMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/16.
//

import SwiftUI
import SwiftData

struct FavoriteMusicView: View {
    @StateObject var favoriteMusicDataStore = FavoriteMusicDataStore.shared
    @StateObject var playDataStore = PlayDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    
    var body: some View {
        VStack {
            if favoriteMusicDataStore.favoriteMusicArray.isEmpty {
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
                        Text("すべて再生 (" + String(favoriteMusicDataStore.favoriteMusicArray.count) + "曲)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                })
                .foregroundStyle(.primary)
                List(favoriteMusicDataStore.favoriteMusicArray) { music in
                    FavoriteMusicViewCell(music: music)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            PlayWindowView()
        }
        .navigationTitle("お気に入り")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .padding(.horizontal)
        .onAppear() {
            if !FavoriteMusicRepository.isExistFavoriteMusicM3U8() {
                if FavoriteMusicRepository.createFavoriteMusicM3U8() {
                    print("createSucceeded")
                }
            }
            Task {
                favoriteMusicDataStore.favoriteMusicArray = await FavoriteMusicRepository.getFavoriteMusics()
            }
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                favoriteMusicDataStore.favoriteMusicArraySort(mode: .nameAscending)
            }, label: {
                Text("曲名昇順")
            })
            Button(action: {
                favoriteMusicDataStore.favoriteMusicArraySort(mode: .nameDescending)
            }, label: {
                Text("曲名降順")
            })
            Button(action: {
                favoriteMusicDataStore.favoriteMusicArraySort(mode: .dateAscending)
            }, label: {
                Text("更新日昇順")
            })
            Button(action: {
                favoriteMusicDataStore.favoriteMusicArraySort(mode: .dateDescending)
            }, label: {
                Text("更新日降順")
            })
        } label: {
            Label("並び替え", systemImage: "arrow.up.arrow.down.circle")
        }
    }
    func randomPlay() {
        guard let music = favoriteMusicDataStore.favoriteMusicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: favoriteMusicDataStore.favoriteMusicArray.map { $0.filePath })
    }
}

#Preview {
    FavoriteMusicView()
}
