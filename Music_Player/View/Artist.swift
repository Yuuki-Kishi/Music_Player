//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Artist: View {
    @Binding private var artistArray: [(artistName: String, musicCount: Int)]
    
    init(artistArray: [(artistName: String, musicCount: Int)]) {
        self.artistArray = artistArray
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(artistArray.count) + "人のアーティスト")
                        .font(.system(size: 15))
                        .frame(height: 20)
                    Spacer()
                }
                List {
                    ForEach(Array(artistArray.enumerated()), id: \.element.artistName) { index, artist in
                        let artistName = artist.artistName
                        NavigationLink(artistName, value: artistName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    ListMusic(navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusic()
            }
            .navigationTitle("アーティスト")
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
