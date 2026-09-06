//
//  PlayModeView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/25.
//

import SwiftUI

struct PlayModeView: View {
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                PlayRepository.toggleIsShuffle()
            } label: {
                Image(systemName: "shuffle")
                    .foregroundStyle(playDataStore.isShuffle ? .accent : .secondary)
            }
            Spacer()
            Button {
                pathDataStore.playViewNavigationPath.append(.playFlow)
            } label: {
                Image(systemName: "list.bullet")
                    .foregroundStyle(.accent)
            }
            Spacer()
            Button {
                PlayRepository.changeRepeatMode()
            } label: {
                Image(systemName: repeatModeImageString())
                    .foregroundStyle(repeatModeImageColor())
            }
            Spacer()
        }
    }
    func repeatModeImageString() -> String {
        switch playDataStore.repeatMode {
        case .all:
            return "repeat"
        case .one:
            return "repeat.1"
        case .off:
            return "repeat"
        }
    }
    func repeatModeImageColor() -> Color {
        switch playDataStore.repeatMode {
        case .all:
            return .accent
        case .one:
            return .accent
        case .off:
            return .secondary
        }
    }
}

#Preview {
    PlayModeView()
}
