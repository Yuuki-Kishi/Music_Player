//
//  CancelButton.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/07/27.
//

import SwiftUI

struct CancelButton: View {
    private let action: () -> Void
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    var body: some View {
        Button(role: .cancel, action: action) {
            Text("CancelButton.Button.Text")
        }
    }
}

#Preview {
    CancelButton()
}
