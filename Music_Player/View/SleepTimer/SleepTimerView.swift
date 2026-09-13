//
//  SleepTimer.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/05/16.
//

import SwiftUI

struct SleepTimerView: View {
    @EnvironmentObject private var timerDataStore: TimerDataStore
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                if timerDataStore.sleepTimer == nil {
                    Text("SleepTimerView.timerExplaination")
                    TimePickerView(time: $timerDataStore.remainTime)
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                } else {
                    Text(timerDataStore.remainTime.timeFormatted)
                        .font(.system(size: 50))
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                }
                Spacer()
                Button {
                    buttonAction()
                } label: {
                    Text(buttonText())
                        .frame(width: geometry.size.width * 0.66, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 3)
                                .foregroundStyle(buttonColor())
                                .frame(width: geometry.size.width * 0.66, height: 30)
                        )
                }
                Spacer()
            }
        }
        .navigationTitle("SleepTimerView.navigationTitle")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    func buttonAction() {
        guard timerDataStore.sleepTimer != nil else { timerDataStore.sleepTimer = nil; return }
        TimerRepository.setTimer()
    }
    func buttonText() -> LocalizedStringKey {
        timerDataStore.sleepTimer == nil ? "SleepTimerView.buttonText.set" : "SleepTimerView.buttonText.stop"
    }
    func buttonColor() -> Color {
        guard timerDataStore.sleepTimer == nil else { return .red }
        guard timerDataStore.remainTime != .zero else { return .secondary }
        return .accent
    }
}

#Preview {
    SleepTimerView()
}
