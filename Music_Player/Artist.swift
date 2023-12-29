//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Artist: View {
    @State var progressValue = Singleton.shared.progressValue
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
                    listMusic(navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                playingMusic()
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
        artistArray.append("アーティスト名")
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    Artist()
}
