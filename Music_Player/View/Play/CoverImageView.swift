//
//  CoverImageView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/25.
//

import SwiftUI

struct CoverImageView: View {
    @EnvironmentObject private var playDataStore: PlayDataStore
    private let geometry: GeometryProxy
    private let size: CGFloat
    private let cornerRadius: CGFloat
    
    init(geometry: GeometryProxy) {
        self.geometry = geometry
        self.size = geometry.size.height * 0.35
        self.cornerRadius = geometry.size.height * 0.07
    }
    
    var body: some View {
        if let data = playDataStore.playingMusic?.coverImage, !data.isEmpty, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .padding()
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(Color(UIColor.systemGray4))
                    .frame(width: size, height: size)
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color(UIColor.systemGray))
                    .frame(width: size * 0.5, height: size * 0.5)
            }
            .padding()
        }
    }
}

//#Preview {
//    CoverImageView(geometry: )
//}
