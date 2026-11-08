//
//  AudioRoutePicker.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/11/07.
//

import SwiftUI
import AVKit

struct AudioRoutePicker: UIViewRepresentable {

    func makeUIView(context: Context) -> AVRoutePickerView {
        let picker = AVRoutePickerView()
        picker.tintColor = .label
        picker.activeTintColor = .systemBlue
        // 映像機器より音声機器を優先
        picker.prioritizesVideoDevices = false

        return picker
    }

    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        
    }
}

#Preview {
    AudioRoutePicker()
}
