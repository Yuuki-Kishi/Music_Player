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
            Slider(value: $playDataStore.displaySeekPosition, in: 0 ... (playDataStore.playingMusic?.musicLength ?? 300)) { isEditing in
                playDataStore.isEditingSeekPosition = isEditing
                if !isEditing {
                    playDataStore.seekPosition = playDataStore.displaySeekPosition
                    PlayRepository.setSeek()
                }
            }
            .onChange(of: playDataStore.seekPosition) {
                if !playDataStore.isEditingSeekPosition {
                    playDataStore.displaySeekPosition = playDataStore.seekPosition
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
        return playDataStore.displaySeekPosition.formattedTime
    }
    func remainTimeString() -> String {
        guard playDataStore.playingMusic != nil else { return "--:--"}
        return ((playDataStore.playingMusic?.musicLength ?? 300) - playDataStore.displaySeekPosition).formattedTime
    }
}

#Preview {
    SliderView()
}
