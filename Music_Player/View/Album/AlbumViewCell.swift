//
//  AlbumMusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct AlbumViewCell: View {
    @StateObject var albumDataStore = AlbumDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State var album: Album
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
            Text(album.albumName)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(String(album.musicCount) + "曲")
        }
        .onTapGesture {
            albumDataStore.selectedAlbum = album
            pathDataStore.albumViewNavigationPath.append(.albumMusic)
        }
    }
}

#Preview {
    AlbumViewCell(album: Album())
}
