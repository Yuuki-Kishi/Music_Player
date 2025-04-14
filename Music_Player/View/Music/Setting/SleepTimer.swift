//
//  SleepTimer.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/05/16.
//

import SwiftUI

struct SleepTimer: View {
    @ObservedObject var viewDataStore: ViewDataStore
    @State private var hour: Int = 0
    @State private var min: Int = 0
    @State private var sec: Int = 0
    @State var isShowAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            if viewDataStore.sleepTimer == nil {
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
                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
                Spacer()
                Button(action: {
                    viewDataStore.setTimer(setTime: hour * 3600 + min * 60 + sec)
                }, label: {
                    Text(buttonText())
                        .frame(width: UIScreen.main.bounds.width * 0.66, height: 30)
                        .foregroundStyle(buttonColor())
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 3)
                                .foregroundStyle(buttonColor())
                                .frame(width: UIScreen.main.bounds.width * 0.66, height: 30)
                        )
                })
                Spacer()
            } else {
                Text(viewDataStore.remainTime.toTime)
                    .font(.system(size: 50))
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
                Spacer()
                Button(action: {
                    viewDataStore.sleepTimer = nil
                }, label: {
                    Text("停止")
                        .frame(width: UIScreen.main.bounds.width * 0.66, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 3)
                                .frame(width: UIScreen.main.bounds.width * 0.66, height: 30)
                        )
                })
                Spacer()
            }
        }
        .navigationTitle("スリープタイマー")
        .navigationBarTitleDisplayMode(.inline)
        .alert("設定しました", isPresented: $isShowAlert, actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        })
        .padding()
    }
    func buttonText() -> String {
        if viewDataStore.sleepTimer == nil {
            return "設定"
        } else {
            return "停止"
        }
    }
    func buttonColor() -> Color {
        if viewDataStore.sleepTimer == nil {
            if hour == 0 && min == 0 && sec == 0 {
                return Color.secondary
            } else {
                return Color.accent
            }
        } else {
            return .red
        }
    }
}

#Preview {
    SleepTimer(viewDataStore: ViewDataStore.shared)
}
