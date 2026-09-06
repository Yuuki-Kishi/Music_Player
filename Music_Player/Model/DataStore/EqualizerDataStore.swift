//
//  EqualizerDataStore.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/24.
//

import Foundation

@MainActor
class EqualizerDataStore: ObservableObject {
    static let shared = EqualizerDataStore()
    @Published var equalizerParameters: [EqualizerParameter] = []
    @Published var isLoading: Bool = false
    let frequencys: [Float] = [32.0, 64.0, 128.0, 256.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0, 16000.0]
    
}
