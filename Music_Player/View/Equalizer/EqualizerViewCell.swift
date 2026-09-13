//
//  EqualizerViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/13.
//

import SwiftUI

struct EqualizerViewCell: View {
    @Binding private var gain: Float
    private let frequency: Float
    
    init(gain: Binding<Float>, frequency: Float) {
        self._gain = gain
        self.frequency = frequency
    }
    
    var body: some View {
        HStack {
            Text(frequencyString())
                .frame(width: 60, alignment: .trailing)
            Slider(value: $gain, in: -12.0...12.0, step: 1.0)
            Text(String(Int(gain)) + "dB")
                .frame(width: 60, alignment: .trailing)
        }
    }
    func frequencyString() -> String {
        guard frequency >= 1000 else { return String(Int(frequency)) + "Hz" }
        return String(Int(frequency / 1000)) + "kHz"
    }
}

#Preview {
    EqualizerViewCell(gain: Binding(get: { 0.0 }, set: {_ in}), frequency: 500.0)
}
