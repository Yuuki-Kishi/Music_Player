//
//  SettingView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/14.
//

import SwiftUI

struct SettingView: View {    
    var body: some View {
        VStack {
            List {
                SettingViewCell(cellType: .excludeFolder)
                SettingViewCell(cellType: .equalizer)
                SettingViewCell(cellType: .sleepTimer)
            }
            .listStyle(.plain)
            .scrollEdgeEffectStyle(.soft, for: .vertical)
            .navigationTitle("SettingView.navigationTitle")
            VersionView()
        }
    }
}

#Preview {
    SettingView()
}
