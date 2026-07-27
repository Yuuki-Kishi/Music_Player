//
//  EqualizerViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/13.
//

import SwiftUI

struct EqualizerViewCell: View {
    @Binding var gain: Float
    @State var frequency: Float
    
    var body: some View {
        HStack {
            Text(frequencyString())
                .frame(width: 60, alignment: .trailing)
            Slider(value: $gain, in: -24.0...24.0, step: 1.0)
            Text(String(Int(gain)) + "dB")
                .frame(width: 60, alignment: .trailing)
        }
    }
    func frequencyString() -> String {
        if frequency >= 1000 {
            return String(Int(frequency / 1000)) + "kHz"
        } else {
            return String(Int(frequency)) + "Hz"
        }
    }
}

#Preview {
    EqualizerViewCell(gain: Binding(get: { 0.0 }, set: {_ in}), frequency: 500.0)
}
