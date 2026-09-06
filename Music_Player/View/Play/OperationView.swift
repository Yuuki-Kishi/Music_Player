//
//  OperationView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/25.
//

import SwiftUI

struct OperationView: View {
    @EnvironmentObject private var musicDataStore: MusicDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                PlayRepository.movePreviousMusic()
            } label: {
                Image(systemName: "backward.fill")
                    .font(.system(size: 25.0))
                    .foregroundStyle(.primary)
            }
            Spacer()
            Button {
                playButtonAction()
            } label: {
                Image(systemName: playButtonImage())
                    .font(.system(size: 40.0))
                    .foregroundStyle(.primary)
            }
            Spacer()
            Button {
                PlayRepository.moveNextMusic()
            } label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 25.0))
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
        .padding(.vertical)
    }
    func playButtonAction() {
        if playDataStore.playingMusic == nil {
            PlayRepository.randomPlay(musics: musicDataStore.musicArray)
        } else {
            if playDataStore.isPlaying {
                PlayRepository.pause()
            } else {
                PlayRepository.play()
            }
        }
    }
    func playButtonImage() -> String {
        if playDataStore.isPlaying {
            return "pause.fill"
        } else {
            return "play.fill"
        }
    }
}

#Preview {
    OperationView()
}
