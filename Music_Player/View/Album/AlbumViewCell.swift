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
            Image(systemName: "music.note")
                .font(.system(size: 20.0))
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .foregroundStyle(Color(UIColor.systemGray5))
                        .frame(width: 30, height: 30)
                )
            Text(album.albumName)
                .font(.system(size: 20.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text(String(album.musicCount) + "曲")
                .font(.system(size: 15.0))
                .foregroundStyle(.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            albumDataStore.selectedAlbum = album
            pathDataStore.albumViewNavigationPath.append(.albumMusic)
        }
    }
}

#Preview {
    AlbumViewCell(album: Album())
}
