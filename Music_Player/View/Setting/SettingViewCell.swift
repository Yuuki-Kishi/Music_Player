//
//  SettingViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/14.
//

import SwiftUI

struct SettingViewCell: View {
    @ObservedObject var pathDataStore: PathDataStore
    @State var title: String
    @State var systemIcon: String
    @State var destination: PathDataStore.MusicViewPath
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: systemIcon)
                .foregroundStyle(.accent)
                .font(.system(size: 20))
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            pathDataStore.musicViewNavigationPath.append(destination)
        }
    }
}

#Preview {
    SettingViewCell(pathDataStore: PathDataStore.shared, title: "イコライザ", systemIcon: "slider.vertical.3", destination: .equalizer)
}
