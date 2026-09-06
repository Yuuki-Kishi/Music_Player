//
//  SettingViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/14.
//

import SwiftUI

struct SettingViewCell: View {
    @EnvironmentObject private var pathDataStore: PathDataStore
    private let cellType: CellTypeEnum
    
    enum CellTypeEnum {
        case excludeFolder, equalizer, sleepTimer
    }
    
    init(cellType: CellTypeEnum) {
        self.cellType = cellType
    }
    
    var body: some View {
        HStack {
            Text(titleString())
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: systemNameString())
                .foregroundStyle(.accent)
                .font(.system(size: 20))
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            tapped()
        }
    }
    func titleString() -> LocalizedStringKey {
        switch cellType {
        case .excludeFolder:
            return "SettingViewCell.Title.excludeFolder.Text"
        case .equalizer:
            return "SettingViewCell.Title.equalizer.Text"
        case .sleepTimer:
            return "SettingViewCell.Title.sleepTimer.Text"
        }
    }
    func systemNameString() -> String {
        switch cellType {
        case .excludeFolder:
            return "folder.fill.badge.gearshape"
        case .equalizer:
            return "slider.vertical.3"
        case .sleepTimer:
            return "timer"
        }
    }
    func tapped() {
        switch cellType {
        case .excludeFolder:
            pathDataStore.musicViewNavigationPath.append(.excludeFolderSelect)
        case .equalizer:
            pathDataStore.musicViewNavigationPath.append(.equalizer)
        case .sleepTimer:
            pathDataStore.musicViewNavigationPath.append(.sleepTimer)
        }
    }
}

#Preview {
    SettingViewCell(cellType: .excludeFolder)
}
