//
//  FolderView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct FolderView: View {
    @EnvironmentObject private var folderDataStore: FolderDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    
    var body: some View {
        NavigationStack(path: $pathDataStore.folderViewNavigationPath) {
            VStack {
                BoolSwitchView(isEmpty: folderDataStore.folderArray.isEmpty, isLoading: folderDataStore.isLoading) {
                    Text("\(String(folderDataStore.folderArray.count))FolderView.content.Text")
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    List(folderDataStore.folderArray) { folder in
                        FolderViewCell(folder: folder)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                } emptyContent: {
                    Text("FolderView.emptyContent.Text")
                }
                PlayWindowView()
            }
            .navigationTitle("FolderView.navigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PathDataStore.FolderViewPath.self) { path in
                destination(path: path)
            }
            .sheet(isPresented: $folderDataStore.isShowAddPlaylistView) {
                AddPlaylistView(music: folderDataStore.folderMusicArray.selected)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    toolBarMenu()
                }
            }
            .onAppear() {
                getFolders()
            }
        }
    }
    @ViewBuilder
    func destination(path: PathDataStore.FolderViewPath) -> some View {
        switch path {
        case .folderMusic:
            FolderMusicView()
        case .musicInfo:
            MusicInfoView(music: folderDataStore.folderMusicArray.selected)
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            ReloadButton {
                getFolders()
            }
            Menu {
                Button {
                    FolderRepository.sortAndUpdateFolderSortMode(sortMode: .nameAscending)
                } label: {
                    Text("FolderView.toolBarMenu.sort.nameAscending.Text")
                }
                Button {
                    FolderRepository.sortAndUpdateFolderSortMode(sortMode: .nameDescending)
                } label: {
                    Text("FolderView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    FolderRepository.sortAndUpdateFolderSortMode(sortMode: .countAscending)
                } label: {
                    Text("FolderView.toolBarMenu.sort.countAscending.Text")
                }
                Button {
                    FolderRepository.sortAndUpdateFolderSortMode(sortMode: .countDescending)
                } label: {
                    Text("FolderView.toolBarMenu.sort.countDescending.Text")
                }
            } label: {
                Label("FolderView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getFolders() {
        Task {
            folderDataStore.isLoading = true
            folderDataStore.folderArray = await FolderRepository.getFolders()
            FolderRepository.sortFolderArray()
            folderDataStore.isLoading = false
        }
    }
}

#Preview {
    FolderView()
}
