//
//  AlbumMusicViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct AlbumViewCell: View {
    @EnvironmentObject private var albumDataStore: AlbumDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    private let album: Album
    
    init(album: Album) {
        self.album = album
    }
    
    var body: some View {
        HStack {
            Image(systemName: "music.pages")
                .font(.system(size: 30.0))
                .foregroundStyle(.accent)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .foregroundStyle(Color(UIColor.systemGray5))
                        .frame(width: 50, height: 50)
                )
            Text(album.albumName)
                .lineLimit(1)
                .font(.system(size: 20.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text("\(String(album.musicCount))AlbumViewCell.musicCount.Text")
                .font(.system(size: 15.0))
                .foregroundStyle(.secondary)
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            albumDataStore.selectedAlbumName = album.albumName
            pathDataStore.albumViewNavigationPath.append(.albumMusic)
        }
    }
}

#Preview {
    AlbumViewCell(album: Album())
}
