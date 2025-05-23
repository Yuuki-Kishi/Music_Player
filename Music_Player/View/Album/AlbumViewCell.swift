//
//  AlbumMusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct AlbumViewCell: View {
    @ObservedObject var albumDataStore: AlbumDataStore
    @ObservedObject var pathDataStore: PathDataStore
    @State var album: Album
    
    var body: some View {
        HStack {
            Image(systemName: "square.stack.fill")
                .font(.system(size: 30.0))
                .foregroundStyle(.accent)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .foregroundStyle(Color(UIColor.systemGray5))
                        .frame(width: 50, height: 50)
                )
            Text(album.albumName)
                .font(.system(size: 20.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text(String(album.musicCount) + "曲")
                .font(.system(size: 15.0))
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            albumDataStore.selectedAlbum = album
            pathDataStore.albumViewNavigationPath.append(.albumMusic)
        }
    }
}

#Preview {
    AlbumViewCell(albumDataStore: AlbumDataStore.shared, pathDataStore: PathDataStore.shared,  album: Album())
}
