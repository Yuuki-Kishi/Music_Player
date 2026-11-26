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
        BoolSwitchView(isEmpty: folderDataStore.folderMusicArray.isEmpty, isLoading: folderDataStore.isLoading) {
            ZStack {
                List(folderDataStore.folderMusicArray) { music in
                    FolderMusicViewCell(music: music)
                        .listRowInsets(.top, folderDataStore.folderMusicArray.first == music ? 65 : 11)
                        .listRowSeparator(folderDataStore.folderMusicArray.first == music ? .hidden : .visible, edges: .top)
                }
                .listStyle(.plain)
                .scrollEdgeEffectStyle(.soft, for: .vertical)
                RandomPlayButton(dataStore: .folder)
            }
        } emptyContent: {
            Text("FolderMusicView.emptyContent.Text")
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
