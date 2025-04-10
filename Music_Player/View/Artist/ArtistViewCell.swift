//
//  ArtistViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/01.
//

import SwiftUI

struct ArtistViewCell: View {
    @StateObject var artistDataStore = ArtistDataStore.shared
    @StateObject var pathDataStore = PathDataStore.shared
    @State var artist: Artist
    
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
            Text(String(artist.musicCount) + "曲")
                .font(.system(size: 15.0))
                .foregroundStyle(.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            artistDataStore.selectedArtist = artist
            pathDataStore.artistViewNavigationPath.append(.artistMusic)
        }
    }
}

#Preview {
    ArtistViewCell(artist: Artist())
}
