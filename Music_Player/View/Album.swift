//
//  Album.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Album: View {
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(vm.musicArray.count) + "枚のアルバム")
                        .font(.system(size: 15))
                        .frame(height: 20)
                    Spacer()
                }
                List {
                    ForEach(Array(vm.musicArray.enumerated()), id: \.element.album) { index, music in
                        let albumName = music.album
                        NavigationLink(albumName, value: albumName)
                    }
                }
                .navigationDestination(for: String.self) { title in
//                    ListMusic(navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusic()
            }
            .navigationTitle("アルバム")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
//            arrayPlus()
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
