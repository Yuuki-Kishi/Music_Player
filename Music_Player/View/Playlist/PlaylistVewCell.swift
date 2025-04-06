//
//  PlaylistVewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct PlaylistViewCell: View {
    @StateObject var playlistDataStore = PlaylistDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State var playlist: Playlist
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
            Text(playlist.playlistName)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(String(playlist.musicCount) + "曲")
        }
        .onTapGesture {
            playlistDataStore.selectedPlaylist = playlist
            pathDataStore.playlistViewNavigationPath.append(.playlistMusic)
        }
    }
}

#Preview {
    PlaylistViewCell(playlist: Playlist())
}
