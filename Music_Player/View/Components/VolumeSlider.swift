//
//  VolumeSlider.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/09/05.
//

import SwiftUI
import MediaPlayer

struct VolumeSlider: UIViewRepresentable {
    @Binding var volume: Float
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView()
        if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            let transparentImage = UIImage()
            slider.setThumbImage(transparentImage, for: .normal)
            slider.setThumbImage(transparentImage, for: .highlighted)
            slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        }
        return volumeView
    }

    func updateUIView(_ uiView: MPVolumeView, context: Context) {
        
    }
    
    class Coordinator: NSObject {
        var parent: VolumeSlider
        
        init(_ parent: VolumeSlider) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.volume = sender.value
        }
    }
}

//#Preview {
//    VolumeSlider(volume: )
//}
