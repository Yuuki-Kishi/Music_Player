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
                } emptyContent: {}
                    .padding(.horizontal)
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
        .navigationTitle("EqualizerView.NavigationTitle")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ResetButton {
                    isShowAlert = true
                }
            }
        }
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
            await EqualizerParameterRepository.resetAll()
            await EqualizerParameterRepository.save()
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
