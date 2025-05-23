//
//  FolderMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct FolderMusicView: View {
    @ObservedObject var folderDataStore: FolderDataStore
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var viewDataStore: ViewDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                Text("読み込み中...")
                Spacer()
            } else {
                if folderDataStore.folderMusicArray.isEmpty {
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
                            Text("シャッフル再生 (" + String(folderDataStore.folderMusicArray.count) + "曲)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal)
                    })
                    .foregroundStyle(.primary)
                    List(folderDataStore.folderMusicArray) { music in
                        FolderMusicViewCell(folderDataStore: folderDataStore, playDataStore: playDataStore, pathDataStore: pathDataStore, music: music)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            PlayWindowView(viewDataStore: viewDataStore, playDataStore: playDataStore)
        }
        .navigationTitle(folderDataStore.selectedFolder?.folderName ?? "不明なアルバム")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onAppear() {
            getFolderMusics()
        }
        .onDisappear() {
            isLoading = true
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                reloadData()
            }, label: {
                Label("再読み込み", systemImage: "arrow.clockwise")
            })
            Menu {
                Button(action: {
                    folderDataStore.folderMusicArraySort(mode: .nameAscending)
                    folderDataStore.saveMusicSortMode()
                }, label: {
                    Text("曲名昇順")
                })
                Button(action: {
                    folderDataStore.folderMusicArraySort(mode: .nameDescending)
                    folderDataStore.saveMusicSortMode()
                }, label: {
                    Text("曲名降順")
                })
                Button(action: {
                    folderDataStore.folderMusicArraySort(mode: .dateAscending)
                    folderDataStore.saveMusicSortMode()
                }, label: {
                    Text("更新日昇順")
                })
                Button(action: {
                    folderDataStore.folderMusicArraySort(mode: .dateDescending)
                    folderDataStore.saveMusicSortMode()
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
    func getFolderMusics() {
        Task {
            guard let folderPath = folderDataStore.selectedFolder?.folderPath else { return }
            folderDataStore.folderMusicArray = await FolderRepository.getFolderMusic(folderPath: folderPath)
            folderDataStore.loadMusicSort()
            isLoading = false
        }
    }
    func reloadData() {
        isLoading = true
        getFolderMusics()
    }
    func randomPlay() {
        guard let music = folderDataStore.folderMusicArray.randomElement() else { return }
        playDataStore.setPlayMode(playMode: .shuffle)
        playDataStore.musicChoosed(music: music, playGroup: .folder)
        playDataStore.setNextMusics(musicFilePaths: folderDataStore.folderMusicArray.map { $0.filePath })
    }
}

#Preview {
    FolderMusicView(folderDataStore: FolderDataStore.shared, playDataStore: PlayDataStore.shared, viewDataStore: ViewDataStore.shared, pathDataStore: PathDataStore.shared)
}
