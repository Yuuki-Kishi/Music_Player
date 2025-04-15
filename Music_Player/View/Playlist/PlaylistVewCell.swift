//
//  PlaylistVewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct PlaylistViewCell: View {
    @ObservedObject var playlistDataStore: PlaylistDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State var playlist: Playlist
    
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
                .font(.system(size: 20.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text(String(playlist.musicCount) + "曲")
                .font(.system(size: 15.0))
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            playlistDataStore.selectedPlaylist = playlist
            pathDataStore.playlistViewNavigationPath.append(.playlistMusic)
        }
    }
}

#Preview {
    PlaylistViewCell(playlistDataStore: PlaylistDataStore.shared, pathDataStore: PathDataStore.shared, playlist: Playlist())
}
