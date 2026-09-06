//
//  DisplayFolderSelectView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/15.
//

import SwiftUI

struct ExcludeFolderSelectView: View {
    @EnvironmentObject private var excludeFolderDataStore: ExcludeFolderDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    
    var body: some View {
        ZStack {
            BoolSwitchView(isEmpty: excludeFolderDataStore.selectableFolderArray.isEmpty, isLoading: excludeFolderDataStore.isLoading) {
                List(excludeFolderDataStore.selectableFolderArray, id: \.self, selection: $excludeFolderDataStore.selectionValue) { folder in
                    ExcludeFolderSelectViewCell(folder: folder)
                }
                .environment(\.editMode, .constant(.active))
                .listStyle(.plain)
            } emptyContent: {
                Text("ExcludeFolderSelectView.emptyContent.Text")
            }
        }
        .navigationTitle("ExcludeFolderSelectView.navigationTitle")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CheckMarkButton {
                    done()
                }
            }
        }
        .onAppear() {
            getSelectableFolderArray()
        }
    }
    func getSelectableFolderArray() {
        excludeFolderDataStore.isLoading = true
        excludeFolderDataStore.excludeFolderArray = ExcludeFolderRepository.getExcludeFolders()
        excludeFolderDataStore.selectableFolderArray = ExcludeFolderRepository.getSelectableFolders()
        excludeFolderDataStore.selectionValue = Set(excludeFolderDataStore.selectableFolderArray.filter { !$0.isExclude })
        ExcludeFolderRepository.sortFolderArray()
        excludeFolderDataStore.isLoading = false
    }
    func done() {
        excludeFolderDataStore.excludeFolderArray = excludeFolderDataStore.selectableFolderArray.filter { !$0.isSelected }
        guard ExcludeFolderRepository.updateExcludeFolder() else { return }
        print("updateSucceeded")
        pathDataStore.musicViewNavigationPath.removeLast()
    }
}

#Preview {
    ExcludeFolderSelectView()
}
