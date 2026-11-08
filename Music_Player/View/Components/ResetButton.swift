//
//  ResetButton.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/11/08.
//

import SwiftUI

struct ResetButton: View {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.counterclockwise")
        }
    }
}

#Preview {
    ResetButton() {}
}
