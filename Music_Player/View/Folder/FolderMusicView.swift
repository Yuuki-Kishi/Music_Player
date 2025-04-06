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
    
    var body: some View {
        VStack {
            if folderDataStore.folderMusicArray.isEmpty {
                Text("表示できる曲がありません")
            } else {
                Button(action: {
                    randomPlay()
                }, label: {
                    HStack {
                        Image(systemName: "play.circle")
                            .foregroundStyle(.accent)
                        Text("すべて再生 (" + String(folderDataStore.folderMusicArray.count) + "曲)")
                    }
                })
                List(folderDataStore.folderMusicArray) { music in
                    FolderMusicViewCell(music: music)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            PlayWindowView()
        }
        .navigationTitle(folderDataStore.selectedFolder?.folderName ?? "不明なアルバム")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .padding(.horizontal)
        .onAppear() {
            Task {
                folderDataStore.folderMusicArray = await FolderRepository.getFolderMusic(folderName: folderDataStore.selectedFolder?.folderName ?? "不明なアルバム")
            }
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
    func randomPlay() {
        guard let music = folderDataStore.folderMusicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: folderDataStore.folderMusicArray.map { $0.filePath })
    }
}

#Preview {
    FolderMusicView()
}
