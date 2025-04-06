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
            Image(systemName: "person.crop.circle")
            Text(artist.artistName)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(String(artist.musicCount) + "曲")
        }
        .onTapGesture {
            artistDataStore.selectedArtist = artist
            pathDataStore.artistViewNavigationPath.append(.artistMusic)
        }
    }
}

#Preview {
    ArtistViewCell(artist: Artist())
}
