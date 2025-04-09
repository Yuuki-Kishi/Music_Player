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
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack(path: $pathDataStore.folderViewNavigationPath) {
            ZStack {
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
                                FolderViewCell(folder: folder)
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
            isLoading = false
        }
    }
}

#Preview {
    FolderView()
}
