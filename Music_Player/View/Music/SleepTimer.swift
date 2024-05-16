//
//  SleepTimer.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/05/16.
//

import SwiftUI

struct SleepTimer: View {
    @ObservedObject var pc: PlayController
    @State var interval: TimeInterval = 60
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
            Slider(value: $interval, in: 0 ... 60 * 24, onEditingChanged: {_ in
                
            })
            HStack {
                Text("0時間0分")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
                Spacer()
                Text(restating(min: interval))
                    .font(.system(size: 20))
                Spacer()
                Text("24時間0分")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.gray)
            }
            Spacer()
            Spacer()
            Button(action: {
                pc.timerForSleep(interval: interval)
                isShowAlert = true
            }, label: {
                Text("設定")
                    .foregroundStyle(Color.primary)
            })
            .alert("設定しました", isPresented: $isShowAlert, actions: {
                Button("OK") {
                    isShowAlert = false
                    presentation.wrappedValue.dismiss()
                }
            })
            .frame(width: 200, height: 30)
            .background(RoundedRectangle(cornerRadius: 15.0).fill(Color.purple))
            Spacer()
        }
        .navigationTitle("スリープタイマー")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    func restating(min: TimeInterval) -> String {
        let hour = String(Int(min / 60))
        let min = String(Int(min.truncatingRemainder(dividingBy: 60)))
        let time: String = hour + "時間" + min + "分"
        return time
    }
}
