//
//  EqualizerView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/13.
//

import SwiftUI

struct EqualizerView: View {
    @EnvironmentObject private var equalizerDataStore: EqualizerDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    @State private var isShowAlert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                BoolSwitchView(isLoading: equalizerDataStore.isLoading) {
                    Spacer()
                    ForEach($equalizerDataStore.equalizerParameters, id: \.self) { $equalizerParameter in
                        EqualizerViewCell(gain: $equalizerParameter.gain, frequency: equalizerParameter.frequency)
                    }
                    Spacer()
                    Button {
                        setEqualizerParameters()
                    } label: {
                        Text("EqualizerView.setButton.Text")
                            .frame(width: geometry.size.width * 0.6, height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 1)
                            )
                    }
                    .padding(.bottom)
                    Button {
                        isShowAlert = true
                    } label: {
                        Text("EqualizerView.resetButton.Text")
                            .frame(width: geometry.size.width * 0.6, height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.primary, lineWidth: 1)
                            )
                    }
                } emptyContent: {}
                    .foregroundStyle(.primary)
                Spacer()
            }
        }
        .alert("EqualizerView.Alert.title", isPresented: $isShowAlert) {
            CancelButton()
            Button(role: .destructive) {
                resetEqualizerParameters()
            } label: {
                Text("EqualizerView.Alert.resetButton.Text")
            }
        } message: {
            Text("EqualizerView.Alert.message")
        }
        .padding(.horizontal)
        .navigationTitle("EqualizerView.NavigationTitle")
        .onAppear() {
            onAppear()
        }
    }
    func setEqualizerParameters() {
        Task {
            await EqualizerParameterRepository.save()
            EqualizerParameterRepository.setEqualizer()
            pathDataStore.musicViewNavigationPath.removeLast()
        }
    }
    func resetEqualizerParameters() {
        Task {
            await EqualizerParameterRepository.deleteAll()
            await EqualizerParameterRepository.insert()
            EqualizerParameterRepository.setEqualizer()
            pathDataStore.musicViewNavigationPath.removeLast()
        }
    }
    func onAppear() {
        Task {
            equalizerDataStore.isLoading = true
            equalizerDataStore.equalizerParameters = await EqualizerParameterRepository.getParameters()
            equalizerDataStore.isLoading = false
        }
    }
}

#Preview {
    EqualizerView()
}
