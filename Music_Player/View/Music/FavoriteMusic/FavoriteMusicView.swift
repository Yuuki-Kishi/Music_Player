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
    @State private var isShowAlert: Bool = false
    
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
        .alert("本当に空にしますか？", isPresented: $isShowAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                cleanUpFavoriteMusics()
            }, label: {
                Text("空にする")
            })
        }, message: {
            Text("この操作は取り消すことができません。")
        })
        .onAppear() {
            if !FavoriteMusicRepository.isExistFavoriteMusicM3U8() {
                guard FavoriteMusicRepository.createFavoriteMusicM3U8() else { return }
                print("createSucceeded")
            }
            getFavoriteMusics()
        }
    }
    func toolBarMenu() -> some View {
        Menu {
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
            Divider()
            Button(role: .destructive, action: {
                isShowAlert = true
            }, label: {
                Label("お気に入りを空にする", systemImage: "trash.fill")
            })
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getFavoriteMusics() {
        Task {
            favoriteMusicDataStore.favoriteMusicArray = await FavoriteMusicRepository.getFavoriteMusics()
        }
    }
    func randomPlay() {
        guard let music = favoriteMusicDataStore.favoriteMusicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: favoriteMusicDataStore.favoriteMusicArray.map { $0.filePath })
    }
    func cleanUpFavoriteMusics() {
        guard FavoriteMusicRepository.cleanUpFavorite() else { return }
        favoriteMusicDataStore.favoriteMusicArray.removeAll()
    }
}

#Preview {
    FavoriteMusicView()
}
