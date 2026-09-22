//
//  VersionView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/09/22.
//

import SwiftUI

struct VersionView: View {
    var body: some View {
        Text("Version: " + currentVersionString())
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
    }
    func currentVersionString() -> String {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "----" }
        return currentVersion
    }
}

#Preview {
    VersionView()
}
