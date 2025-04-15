//
//  SettingView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/14.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var pathDataStore: PathDataStore
    
    var body: some View {
        List {
            SettingViewCell(pathDataStore: pathDataStore, title: "読み込むフォルダの管理", systemIcon: "folder.fill.badge.gearshape", destination: .readFolderSelect)
            SettingViewCell(pathDataStore: pathDataStore, title: "イコライザ", systemIcon: "slider.vertical.3", destination: .equalizer)
            SettingViewCell(pathDataStore: pathDataStore, title: "スリープタイマー", systemIcon: "timer", destination: .sleepTImer)
        }
        .listStyle(.plain)
        .navigationTitle("設定")
    }
}

#Preview {
    SettingView(pathDataStore: PathDataStore.shared)
}
