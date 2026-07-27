//
//  DisplayFolderSelectView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/15.
//

import SwiftUI

struct ReadFolderSelectView: View {
    @ObservedObject var pathDataStore: PathDataStore
    @State private var selectionValue: Set<Folder> = []
    @State private var selectableFolderArray: [Folder] = []
    @State private var readFolderArray: [ReadFolder] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            if isLoading {
                Spacer()
                Text("読み込み中...")
                Spacer()
            } else {
                if selectableFolderArray.isEmpty {
                    Spacer()
                    Text("表示できるフォルダがありません")
                    Spacer()
                } else {
                    List(selection: $selectionValue) {
                        ForEach(selectableFolderArray, id: \.self) { folder in
                            ReadFolderSelectViewCell(folder: folder)
                        }
                    }
                    .environment(\.editMode, .constant(.active))
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle("表示するフォルダを選択")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                toolBarMenu()
            })
        }
        .onAppear() {
            getSelectableFolderArray()
        }
    }
    func toolBarMenu() -> some View {
        HStack {
            Button(action: {
                if selectionValue.isEmpty {
                    selectionValue = Set(selectableFolderArray)
                } else {
                    selectionValue = []
                }
            }, label: {
                if selectionValue.isEmpty {
                    Text("全て選択")
                } else {
                    Text("全て解除")
                }
            })
            Button(action: {
                done()
            }, label: {
                Text("完了")
            })
        }
    }
    func getSelectableFolderArray() {
        Task {
            readFolderArray = await ReadFolderRepository.getReadFolders()
            selectableFolderArray = ReadFolderRepository.getSelectableFolders()
            selectableFolderArray.sort { $0.folderName < $1.folderName }
            selectionValue = Set(selectableFolderArray.filter { isContain(folder: $0) })
            isLoading = false
        }
    }
    func isContain(folder: Folder) -> Bool {
        let isRead = readFolderArray.first(where: { $0.folderPath == folder.folderPath })?.isRead ?? false
        let isContain = readFolderArray.contains(where: { $0.folderPath == folder.folderPath })
        return isRead || !isContain ? true : false
    }
    func done() {
        Task {
            await ReadFolderRepository.deleteAll()
            await ReadFolderRepository.createReadFolders(folders: Array(selectionValue))
            let notReadFolders = selectableFolderArray.filter { !selectionValue.contains($0) }
            await ReadFolderRepository.createNotReadFolders(folders: notReadFolders)
            pathDataStore.musicViewNavigationPath.removeLast()
        }
    }
    func isContainSelectionValue(folder: Folder) -> Bool {
        selectionValue.contains(where: { $0.folderPath == folder.folderPath })
    }
}

#Preview {
    ReadFolderSelectView(pathDataStore: PathDataStore.shared)
}
