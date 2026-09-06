//
//  ArtistViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct ArtistViewCell: View {
    @EnvironmentObject private var artistDataStore: ArtistDataStore
    @EnvironmentObject private var pathDataStore: PathDataStore
    private let artist: Artist
    
    init(artist: Artist) {
        self.artist = artist
    }
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .font(.system(size: 30.0))
                .foregroundStyle(.accent)
                .background(
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color(UIColor.systemGray5))
                )
                .frame(width: 40, height: 40)
            Text(artist.artistName)
                .lineLimit(1)
                .font(.system(size: 20.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text("\(String(artist.musicCount))ArtistViewCell.musicCount.Text")
                .font(.system(size: 15.0))
                .foregroundStyle(.secondary)
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            artistDataStore.selectedArtistName = artist.artistName
            pathDataStore.artistViewNavigationPath.append(.artistMusic)
        }
    }
}

#Preview {
    ArtistViewCell(artist: Artist())
}
