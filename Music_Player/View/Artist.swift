//
//  Artist.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/10/25.
//

import SwiftUI

struct Artist: View {
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(String(vm.musicArray.count) + "人のアーティスト")
                        .font(.system(size: 15))
                        .frame(height: 20)
                    Spacer()
                }
                List {
                    ForEach(Array(vm.musicArray.enumerated()), id: \.element.artist) { index, music in
                        let artistName = music.artist
                        NavigationLink(artistName, value: artistName)
                    }
                }
                .navigationDestination(for: String.self) { title in
//                    ListMusic(navigationTitle: title)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                PlayingMusic()
            }
            .navigationTitle("アーティスト")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            //rrayPlus()
        }
        .padding(.horizontal)
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    Artist()
}
