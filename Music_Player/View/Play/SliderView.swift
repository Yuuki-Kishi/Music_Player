//
//  SliderView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/25.
//

import SwiftUI

struct SliderView: View {
    @EnvironmentObject private var playDataStore: PlayDataStore
    
    var body: some View {
        VStack {
            Slider(value: $playDataStore.seekPosition, in: 0 ... (playDataStore.playingMusic?.musicLength ?? 300)) { isEditing in
                if isEditing {
                    playDataStore.seekPositionUpdateTimer?.invalidate()
                } else {
                    PlayRepository.setSeek()
                    PlayRepository.setTimer()
                }
            }
            HStack {
                Text(playTimeString())
                    .font(.system(size: 12.5))
                    .foregroundStyle(.secondary)
                Spacer()
                
                Text(remainTimeString())
                    .font(.system(size: 12.5))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
    }
    func playTimeString() -> String {
        guard playDataStore.playingMusic != nil else { return "--:--"}
        return playDataStore.seekPosition.formattedTime
    }
    func remainTimeString() -> String {
        guard playDataStore.playingMusic != nil else { return "--:--"}
        return ((playDataStore.playingMusic?.musicLength ?? 300) - playDataStore.seekPosition).formattedTime
    }
}

#Preview {
    SliderView()
}
