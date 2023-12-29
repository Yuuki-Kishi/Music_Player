//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Album: View {
    @State var progressValue = Singleton.shared.progressValue
    @State var albumArray = Singleton.shared.albumArray
    
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
                    ForEach(Array(albumArray.enumerated()), id: \.element) { index, albumName in
                        NavigationLink(albumName, value: albumName)
                    }
                }
                .navigationDestination(for: String.self) { title in
                    listMusic(navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                playingMusic()
            }
            .navigationTitle("アルバム")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            arrayPlus()
        }
        .padding(.horizontal)
    }
    func arrayPlus() {
        albumArray = []
        albumArray.append("アルバム名")
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    Album()
}
