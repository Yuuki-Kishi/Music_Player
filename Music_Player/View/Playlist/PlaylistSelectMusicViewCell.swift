//
//  PlaylistSelectMusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct PlaylistSelectMusicViewCell: View {
    private let music: Music
    
    init(music: Music) {
        self.music = music
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(music.musicName)
                    .lineLimit(1)
                    .font(.system(size: 20.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(music.artistAndAlbumName)
                    .lineLimit(1)
                    .font(.system(size: 12.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.secondary)
            }
            Text(music.musicLength.formattedTime)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    PlaylistSelectMusicViewCell(music: Music())
}
