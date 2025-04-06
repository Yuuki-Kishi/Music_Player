//
//  LoadingView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/03/31.
//

import SwiftUI

struct LoadingView: View {
    @StateObject var viewDataStore = ViewDataStore.shared
    
    var body: some View {
        if viewDataStore.isShowLoadingView {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.5)
                .tint(Color.purple)
        }
    }
}

#Preview {
    LoadingView()
}
