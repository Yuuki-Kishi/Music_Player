//
//  DeleteButton.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/07/27.
//

import SwiftUI

struct DeleteButton: View {
    private let action: () -> Void
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    var body: some View {
        Button(role: .destructive, action: action) {
            Text("DeleteButton.Button.Text")
        }
    }
}

#Preview {
    DeleteButton()
}
