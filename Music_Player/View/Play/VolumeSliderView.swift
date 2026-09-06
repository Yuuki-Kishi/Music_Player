//
//  VolumeSliderView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/09/05.
//

import SwiftUI
import AVFAudio

struct VolumeSliderView: View {
    @State private var volume: Float = AVAudioSession.sharedInstance().outputVolume
    
    var body: some View {
        HStack {
            Image(systemName: imageNameString())
                .padding(.bottom, 10)
            VolumeSlider(volume: $volume)
        }
        .frame(height: 30)
        .padding()
    }
    func imageNameString() -> String {
        if volume > 2 / 3 {
            return "speaker.wave.3"
        } else if volume > 1 / 3 {
            return "speaker.wave.2"
        } else if volume > 0 {
            return "speaker.wave.1"
        } else {
            return "speaker.slash"
        }
    }
}

#Preview {
    VolumeSliderView()
}
