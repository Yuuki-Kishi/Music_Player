//
//  FolderMusicView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/06.
//

import SwiftUI

struct FolderMusicView: View {
    @EnvironmentObject private var folderDataStore: FolderDataStore
    
    var body: some View {
        VStack {
            BoolSwitchView(isEmpty: folderDataStore.folderMusicArray.isEmpty, isLoading: folderDataStore.isLoading) {
                RandomPlayButton(dataStore: .folder)
                List(folderDataStore.folderMusicArray) { music in
                    FolderMusicViewCell(music: music)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } emptyContent: {
                Text("FolderMusicView.emptyContent.Text")
            }
            PlayWindowView()
        }
        .navigationTitle(folderDataStore.folderArray.selected?.folderName ?? String(localized: "FolderMusicView.navigationTitle.unknownFolderName"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                toolBarMenu()
            }
        }
        .onAppear() {
            getFolderMusics()
        }
    }
    func toolBarMenu() -> some View {
        Menu {
            ReloadButton {
                getFolderMusics()
            }
            Menu {
                Button {
                    FolderRepository.sortAndUpdateFolderMusicSortMode(sortMode: .nameAscending)
                } label: {
                    Text("FolderMusicView.toolBarMenu.sort.nameAscending.Text")
                }
                Button {
                    FolderRepository.sortAndUpdateFolderMusicSortMode(sortMode: .nameDescending)
                } label: {
                    Text("FolderMusicView.toolBarMenu.sort.nameDescending.Text")
                }
                Button {
                    FolderRepository.sortAndUpdateFolderMusicSortMode(sortMode: .dateAscending)
                } label: {
                    Text("FolderMusicView.toolBarMenu.sort.dateAscending.Text")
                }
                Button {
                    FolderRepository.sortAndUpdateFolderMusicSortMode(sortMode: .dateDescending)
                } label: {
                    Text("FolderMusicView.toolBarMenu.sort.dateDescending.Text")
                }
            } label: {
                Label("FolderMusicView.toolBarMenu.sort.Label", systemImage: "arrow.up.arrow.down")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    func getFolderMusics() {
        Task {
            folderDataStore.isLoading = true
            folderDataStore.folderMusicArray = await FolderRepository.getFolderMusic()
            FolderRepository.sortFolderMusicArray()
            folderDataStore.isLoading = false
        }
    }
}

#Preview {
    FolderMusicView()
}
