//
//  SleepTimer.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/05/16.
//

import SwiftUI

struct SleepTimer: View {
    @ObservedObject var pc: PlayController
    @State var sec: TimeInterval = 0
    @State var min: TimeInterval = 0
    @State var hour: TimeInterval = 1
    @State var isShowAlert = false
    @Environment(\.presentationMode) var presentation
    
    init(pc: PlayController) {
        self.pc = pc
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("指定時間経過後、自動で再生を一時停止します。")
            Spacer()
            VStack {
                HStack {
                    Slider(value: $hour, in: 0 ... 23, step: 1.0)
                    Text(String(Int(hour)) + "時間")
                        .padding(10)
                        .frame(width: 75)
                }
                HStack {
                    Slider(value: $min, in: 0 ... 59, step: 1.0)
                    Text(String(Int(min)) + "分　")
                        .padding(10)
                        .frame(width: 75)
                }
                HStack {
                    Slider(value: $sec, in: 0 ... 59, step: 1.0)
                    Text(String(Int(sec)) + "秒　")
                        .padding(10)
                        .frame(width: 75)
                }
            }
            Spacer()
            let time = hour * 3600 + min * 60 + sec
            if time != 0 {
                Text("設定")
                    .frame(height: 20)
                    .background(RoundedRectangle(cornerRadius: 15.0).fill(Color.purple).frame(width: 225, height: 30))
                    .onTapGesture {
                        pc.timerForSleep(interval: time)
                        isShowAlert = true
                    }
                .alert("設定しました", isPresented: $isShowAlert, actions: {
                    Button("OK") {
                        isShowAlert = false
                        presentation.wrappedValue.dismiss()
                    }
                })
            } else {
                Text("設定")
                    .frame(height: 20)
                    .background(RoundedRectangle(cornerRadius: 15.0, style: .continuous).fill(Color.gray).frame(width: 225, height: 30))
            }
            Spacer()
        }
        .navigationTitle("スリープタイマー")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

#Preview {
    SleepTimer(pc: PlayController.shared)
}
