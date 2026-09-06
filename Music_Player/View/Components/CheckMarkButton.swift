//
//  checkMarkButton.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/07/30.
//

import SwiftUI

struct CheckMarkButton: View {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(role: .confirm, action: action) {
            Image(systemName: "checkmark")
        }
    }
}

#Preview {
    CheckMarkButton() {}
}
