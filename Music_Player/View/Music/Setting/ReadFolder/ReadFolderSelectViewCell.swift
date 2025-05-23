//
//  DisplayFolderSelectViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/15.
//

import SwiftUI

struct ReadFolderSelectViewCell: View {
    @State var folder: Folder
    
    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
                .font(.system(size: 30.0))
                .foregroundStyle(.accent)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .foregroundStyle(Color(UIColor.systemGray5))
                        .frame(width: 50, height: 50)
                )
                .frame(width: 40, height: 40)
            Text(folder.folderName)
                .font(.system(size: 20.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text(String(folder.musicCount) + "曲")
                .font(.system(size: 15.0))
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    ReadFolderSelectViewCell(folder: Folder())
}
