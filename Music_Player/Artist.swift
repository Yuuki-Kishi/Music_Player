//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Artist: View {
    @State var progressValue = Singleton.shared.seekPosition
    @State var artistArray = Singleton.shared.artistArray
    
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
                    ForEach(Array(artistArray.enumerated()), id: \.element) { index, artistName in
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
            arrayPlus()
        }
        .padding(.horizontal)
    }
    func arrayPlus() {
        artistArray = []
        artistArray.append("アーティスト名1")
        artistArray.append("アーティスト名2")
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    Artist()
}
