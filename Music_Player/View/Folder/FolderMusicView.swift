//
//  FolderMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct FolderMusicView: View {
    @StateObject var folderDataStore = FolderDataStore.shared
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
                                Text("すべて再生 (" + String(folderDataStore.folderMusicArray.count) + "曲)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                        })
                        .foregroundStyle(.primary)
                        List(folderDataStore.folderMusicArray) { music in
                            FolderMusicViewCell(music: music)
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
                folderDataStore.folderMusicArraySort(mode: .nameAscending)
            }, label: {
                Text("曲名昇順")
            })
            Button(action: {
                folderDataStore.folderMusicArraySort(mode: .nameDescending)
            }, label: {
                Text("曲名降順")
            })
            Button(action: {
                folderDataStore.folderMusicArraySort(mode: .dateAscending)
            }, label: {
                Text("更新日昇順")
            })
            Button(action: {
                folderDataStore.folderMusicArraySort(mode: .dateDescending)
            }, label: {
                Text("更新日降順")
            })
        } label: {
            Label("並び替え", systemImage: "arrow.up.arrow.down.circle")
        }
    }
    func getFolderMusics() {
        guard let folderPath = folderDataStore.selectedFolder?.folderPath else { return }
        Task {
            folderDataStore.folderMusicArray = await FolderRepository.getFolderMusic(folderPath: folderPath)
            isLoading = false
        }
    }
    func randomPlay() {
        guard let music = folderDataStore.folderMusicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: folderDataStore.folderMusicArray.map { $0.filePath })
    }
}

#Preview {
    FolderMusicView()
}
