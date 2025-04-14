//
//  FolderView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct FolderView: View {
    @StateObject var folderDataStore = FolderDataStore.shared
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var viewDataStore: ViewDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack(path: $pathDataStore.folderViewNavigationPath) {
            VStack {
                if isLoading {
                    Spacer()
                    Text("読み込み中...")
                    Spacer()
                } else {
                    if folderDataStore.folderArray.isEmpty {
                        Spacer()
                        Text("表示できるフォルダがありません")
                        Spacer()
                    } else {
                        Text(String(folderDataStore.folderArray.count) + "個のフォルダ")
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        List(folderDataStore.folderArray) { folder in
                            FolderViewCell(folderDataStore: folderDataStore, pathDataStore: pathDataStore, folder: folder)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
                PlayWindowView(viewDataStore: viewDataStore, playDataStore: playDataStore)
            }
            .navigationTitle("フォルダ")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.FolderViewPath.self) { path in
                destination(path: path)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    toolBarMenu()
                })
            }
            .onAppear() {
                getFolders()
            }
            .onDisappear() {
                isLoading = true
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.FolderViewPath) -> some View {
        switch path {
        case .folderMusic:
            FolderMusicView(folderDataStore: folderDataStore, playDataStore: playDataStore, viewDataStore: viewDataStore, pathDataStore: pathDataStore)
        case .addPlaylist:
            AddPlaylistView(pathDataStore: pathDataStore, music: folderDataStore.selectedMusic ?? Music(), pathArray: .folder)
        case .musicInfo:
            MusicInfoView(music: folderDataStore.selectedMusic ?? Music())
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            Button(action: {
                folderDataStore.folderArraySort(mode: .nameAscending)
                folderDataStore.saveSortMode()
            }, label: {
                Text("フォルダ名昇順")
            })
            Button(action: {
                folderDataStore.folderArraySort(mode: .nameDescending)
                folderDataStore.saveSortMode()
            }, label: {
                Text("フォルダ名降順")
            })
            Button(action: {
                folderDataStore.folderArraySort(mode: .countAscending)
                folderDataStore.saveSortMode()
            }, label: {
                Text("曲数昇順")
            })
            Button(action: {
                folderDataStore.folderArraySort(mode: .countDescending)
                folderDataStore.saveSortMode()
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
            folderDataStore.loadSort()
            isLoading = false
        }
    }
}

#Preview {
    FolderView(folderDataStore: FolderDataStore.shared, playDataStore: PlayDataStore.shared, viewDataStore: ViewDataStore.shared, pathDataStore: PathDataStore.shared)
}
