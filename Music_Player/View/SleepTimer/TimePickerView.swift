//
//  TimePickerView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/22.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var time: Int
    private var hour: Int {
        time / 3600
    }
    private var minute: Int {
        (time % 3600) / 60
    }
    private var second: Int {
        time % 60
    }
    var body: some View {
        HStack {
            Picker("", selection: Binding(
                get: { hour },
                set: { time = $0 * 3600 + minute * 60 + second }
            )) {
                ForEach(0...23, id: \.self) {
                    Text(String(format: "%02d", $0))
                }
            }
            Text(":")
            Picker("", selection: Binding(
                get: { minute },
                set: { time = hour * 3600 + $0 * 60 + second }
            )) {
                ForEach(0...59, id: \.self) {
                    Text(String(format: "%02d", $0))
                }
            }
            Text(":")
            Picker("", selection: Binding(
                get: { second },
                set: { time = hour * 3600 + minute * 60 + $0 }
            )) {
                ForEach(0...59, id: \.self) {
                    Text(String(format: "%02d", $0))
                }
            }
        }
        .pickerStyle(.wheel)
    }
}

#Preview {
    TimePickerView(time: Binding(get: { 0 }, set: {_ in}))
}
