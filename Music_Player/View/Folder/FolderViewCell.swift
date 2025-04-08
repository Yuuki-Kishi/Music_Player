//
//  FolderViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/02.
//

import SwiftUI

struct FolderViewCell: View {
    @StateObject var folderDataStore = FolderDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State var folder: Folder
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
            Text(folder.folderName)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(String(folder.musicCount) + "曲")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            folderDataStore.selectedFolder = folder
            pathDataStore.folderViewNavigationPath.append(.folderMusic)
        }
    }
}

#Preview {
    FolderViewCell(folder: Folder())
}
