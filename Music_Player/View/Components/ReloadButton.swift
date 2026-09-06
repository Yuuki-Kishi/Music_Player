//
//  ReloadButton.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/07/28.
//

import SwiftUI

struct ReloadButton: View {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Label("ReloadButton.Label", systemImage: "arrow.clockwise")
        }
    }
}

#Preview {
    ReloadButton() {}
}
