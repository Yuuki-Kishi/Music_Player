//
//  PlaylistViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct PlaylistViewCell: View {
    @EnvironmentObject private var playlistDataStore: PlaylistDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    private let playlist: Playlist
    
    init(playlist: Playlist) {
        self.playlist = playlist
    }
    
    var body: some View {
        HStack {
            Image(systemName: "music.note.list")
                .font(.system(size: 30.0))
                .foregroundStyle(.accent)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .foregroundStyle(Color(UIColor.systemGray5))
                        .frame(width: 50, height: 50)
                )
                .frame(width: 40, height: 40)
            Text(playlist.playlistName)
                .lineLimit(1)
                .font(.system(size: 20.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text("\(String(playlist.musicCount))PlaylistViewCell.musicCount.Text")
                .font(.system(size: 15.0))
                .foregroundStyle(.secondary)
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            playlistDataStore.selectedPlaylistFilePath = playlist.filePath
            pathDataStore.playlistViewNavigationPath.append(.playlistMusic)
        }
    }
}

#Preview {
    PlaylistViewCell(playlist: Playlist())
}
