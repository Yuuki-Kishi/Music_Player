//
//  EqualizerView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/13.
//

import SwiftUI

struct EqualizerView: View {
    @ObservedObject var playDataStore: PlayDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State private var equalizerParameters: [EqualizerParameter] = []
    @State private var isShowAlert: Bool = false
    let frequencys: [Float] = [32.0, 64.0, 128.0, 256.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0, 16000.0]
    
    var body: some View {
        VStack {
            Spacer()
            ForEach($equalizerParameters, id: \.self) { $equalizerParameter in
                EqualizerViewCell(gain: $equalizerParameter.gain, frequency: equalizerParameter.frequency)
            }
            Spacer()
            Button(action: {
                setEqualizerParameters()
            }, label: {
                Text("イコライザーを設定")
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.accent, lineWidth: 1)
                    )
            })
            .padding(.bottom)
            Button(action: {
                isShowAlert = true
            }, label: {
                Text("イコライザーをリセット")
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 1)
                    )
            })
            .foregroundStyle(.primary)
            Spacer()
        }
        .alert("本当にリセットしますか？", isPresented: $isShowAlert, actions: {
            Button(role: .cancel, action: {}, label: {
                Text("キャンセル")
            })
            Button(role: .destructive, action: {
                resetEqualizerParameters()
            }, label: {
                Text("リセット")
            })
        })
        .padding(.horizontal)
        .navigationTitle("イコライザ")
        .onAppear() {
            onAppear()
        }
    }
    func setEqualizerParameters() {
        Task {
            await EqualizerParameterRepository.deleteAll()
            await EqualizerParameterRepository.create(equalizerParameters: equalizerParameters)
            let equalizerParameters = await EqualizerParameterRepository.read()
            playDataStore.setEqualizer(equalizerParameters: equalizerParameters)
            pathDataStore.musicViewNavigationPath.removeLast()
        }
    }
    func resetEqualizerParameters() {
        Task {
            var equalizerParameters: [EqualizerParameter] = []
            for frequency in frequencys {
                let equalizerParameter = EqualizerParameter(type: 0, bandWidth: 1, frequency: frequency, gain: 0.0)
                equalizerParameters.append(equalizerParameter)
            }
            await EqualizerParameterRepository.deleteAll()
            await EqualizerParameterRepository.create(equalizerParameters: equalizerParameters)
            pathDataStore.musicViewNavigationPath.removeLast()
        }
    }
    func onAppear() {
        Task {
            let equalizerParameters = await EqualizerParameterRepository.read()
            if equalizerParameters.isEmpty {
                var equalizerParameters: [EqualizerParameter] = []
                for frequency in frequencys {
                    let equalizerParameter = EqualizerParameter(type: 0, bandWidth: 1, frequency: frequency, gain: 0.0)
                    equalizerParameters.append(equalizerParameter)
                }
                equalizerParameters.sort { $0.frequency < $1.frequency }
                self.equalizerParameters = equalizerParameters
            } else {
                self.equalizerParameters = equalizerParameters
            }
        }
    }
}

#Preview {
    EqualizerView(playDataStore: PlayDataStore.shared, pathDataStore: PathDataStore.shared)
}
