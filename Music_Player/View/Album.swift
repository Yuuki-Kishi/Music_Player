//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Album: View {
    @Binding private var albumArray: [(musicName: String, artistName: String, albumName: String, belongDirectory: String)]
    
    init(albumArray: [(musicName: String, artistName: String, albumName: String, belongDirectory: String)]) {
        self.albumArray = albumArray
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(albumArray.count) + "枚のアルバム")
                        .font(.system(size: 15))
                        .frame(height: 20)
                    Spacer()
                }
                List {
                    ForEach(Array(albumArray.enumerated()), id: \.element.albumName) { index, album in
                        let albumName = album.albumName
                        NavigationLink(albumName, value: albumName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusic(navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusic()
            }
            .navigationTitle("アルバム")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            
        }
        .padding(.horizontal)
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    Album()
}
