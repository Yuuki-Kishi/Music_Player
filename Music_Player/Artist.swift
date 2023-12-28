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
                    let musicCount = String(artist.musicCount) + "曲"
                    HStack {
                        Text(artistName)
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(musicCount)
                            .font(.system(size: 15))
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(UIColor.systemGray3))
                    }
                    .listRowBackground(Color(UIColor.systemGray6))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            ZStack {
                VStack {
                    ProgressView(value: progressValue, total: 100)
                        .foregroundColor(.purple)
                    HStack {
                        VStack {
                            Text("曲名")
                                .font(.system(size: 20.0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text("アーティスト名")
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("アルバム名")
                                    .font(.system(size: 12.5))
                                    .frame(maxWidth: .infinity,alignment: .leading)
                            }
                        }
                        Button(action: {
                            
                        }){
                            Image(systemName: "play.fill")
                                .foregroundColor(.primary)
                        }
                            .frame(width: 50.0, height: 50.0)
                            .font(.system(size: 30.0))
                        Button(action: {
                            
                        }){
                            Image(systemName: "forward.end.fill")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .onAppear {
            arrayPlus()
        }
        .padding()
    }
    func arrayPlus() {
        artistArray = []
        let array = [(artistName: "アーティスト名", musicCount: 5)]
        artistArray = artistArray + array
    }
    func testPrint() {
        print("敵影感知")
    }
}

#Preview {
    Artist()
}
