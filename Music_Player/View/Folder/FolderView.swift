//
//  FolderView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct FolderView: View {
    @StateObject var folderDataStore = FolderDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    
    var body: some View {
        NavigationStack(path: $pathDataStore.folderViewNavigationPath) {
            VStack {
                if folderDataStore.folderArray.isEmpty {
                    Spacer()
                    Text("表示できるフォルダがありません")
                    Spacer()
                } else {
                    Text(String(folderDataStore.folderArray.count) + "個のアルバム")
                        .font(.system(size: 15))
                        .frame(height: 20)
                    List(folderDataStore.folderArray) { folder in
                        FolderViewCell(folder: folder)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                PlayWindowView()
            }
            .navigationTitle("フォルダ")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .navigationDestination(for: PathDataStore.FolderViewPath.self) { path in
                destination(path: path)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    toolBarMenu()
                })
            }
        }
        .onAppear() {
            getFolders()
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.FolderViewPath) -> some View {
        switch path {
        case .folderMusic:
            FolderMusicView()
        case .addPlaylist:
            AddPlaylistView(music: folderDataStore.selectedMusic ?? Music(), pathArray: .folder)
        case .musicInfo:
            MusicInfoView(music: folderDataStore.selectedMusic ?? Music())
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                folderDataStore.folderArraySort(mode: .nameAscending)
            }, label: {
                Text("アーティスト名昇順")
            })
            Button(action: {
                folderDataStore.folderArraySort(mode: .nameDescending)
            }, label: {
                Text("アーティスト名降順")
            })
            Button(action: {
                folderDataStore.folderArraySort(mode: .countAscending)
            }, label: {
                Text("曲数昇順")
            })
            Button(action: {
                folderDataStore.folderArraySort(mode: .countDescending)
            }, label: {
                Text("曲数降順")
            })
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
    func getFolders() {
        Task {
            folderDataStore.folderArray = await FolderRepository.getFolders()
        }
    }
}

#Preview {
    FolderView()
}
