//
//  SleepTimer.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/05/16.
//

import SwiftUI

struct SleepTimer: View {
    @ObservedObject var pc: PlayController
    @State var sec = 0
    @State var min = 0
    @State var hour = 0
    @State var isShowAlert = false
    @State var isNoTimeAlert = false
    @Environment(\.presentationMode) var presentation
    
    init(pc: PlayController) {
        self.pc = pc
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("指定時間経過後、自動で再生を一時停止します。")
            Spacer()
            HStack {
                Picker("時間", selection: $hour) {
                    ForEach(0 ..< 25) { num in
                        Text(String(num)).tag(num)
                    }
                }
                .pickerStyle(.wheel)
                Text("時間")
                Picker("分", selection: $min, content: {
                    ForEach(0 ..< 60) { num in
                        Text(String(num)).tag(num)
                    }
                })
                .pickerStyle(.wheel)
                Text("分")
                Picker("秒", selection: $sec, content: {
                    ForEach(0 ..< 60) { num in
                        Text(String(num)).tag(num)
                    }
                })
                .pickerStyle(.wheel)
                Text("秒")
            }
            .padding()
            Spacer()
            Text("設定")
                .frame(height: 20)
                .background(RoundedRectangle(cornerRadius: 15.0).fill(Color.purple).frame(width: 225, height: 30))
                .onTapGesture {
                    tapped()
                }
                .alert("設定しました", isPresented: $isShowAlert, actions: {
                    Button("OK") {
                        isShowAlert = false
                        presentation.wrappedValue.dismiss()
                    }
                })
                .alert("0秒を設定できません", isPresented: $isNoTimeAlert, actions: {
                    Button("OK") {
                        isShowAlert = false
                    }
                })
            Spacer()
        }
        .navigationTitle("スリープタイマー")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    func tapped() {
        let time: TimeInterval = Double(hour * 3600) + Double(min * 60) + Double(sec)
        if time != 0 {
            pc.timerForSleep(interval: time)
            isShowAlert = true
        } else {
            isNoTimeAlert = true
        }
    }
}
