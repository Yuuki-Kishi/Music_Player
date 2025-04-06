//
//  playingMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct PlayWindowView: View {
    @StateObject var viewDataStore = ViewDataStore.shared
    @StateObject var playDataStore = PlayDataStore.shared
    
    var body: some View {
        VStack {
            ProgressView(value: playDataStore.seekPosition, total: Double(playDataStore.playingMusic?.musicLength ?? 300))
                .progressViewStyle(LinearProgressViewStyle(tint: .accent))
            ZStack {
//                HStack {
                    VStack {
                        Text(playDataStore.playingMusic?.musicName ?? "再生停止中")
                            .lineLimit(1)
                            .font(.system(size: 20.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(playDataStore.playingMusic?.artistName ?? "")
                                .lineLimit(1)
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(playDataStore.playingMusic?.albumName ?? "")
                                .lineLimit(1)
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity,alignment: .leading)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
//                    Button(action: {}, label: {
//                        Image(systemName: "play.fill")
//                                .padding(14)
//                    })
//                    .font(.system(size: 25.0))
//                    .foregroundStyle(.clear)
//                    Button(action: {}, label: {
//                        Image(systemName: "forward.fill")
//                            .padding(.vertical, 14)
//                    })
//                    .foregroundStyle(.clear)
//                    .font(.system(size: 25.0))
//                }
                Button(action: {
                    viewDataStore.isShowPlayView = true
                }, label: {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(maxWidth: .infinity, maxHeight: 20)
                })
                HStack {
                    Button(action: {
                        if playDataStore.playingMusic != nil {
                            playDataStore.isPlaying.toggle()
                        } else {
                            
                        }
                    }, label: {
                        if playDataStore.isPlaying {
                            Image(systemName: "pause.fill")
                                .padding(14)
                        } else {
                            Image(systemName: "play.fill")
                                .padding(14)
                        }
                    })
                    .font(.system(size: 25.0))
                    .foregroundStyle(.primary)
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "forward.fill")
                            .padding(.vertical, 14)
                    })
                    .foregroundStyle(.primary)
                    .font(.system(size: 25.0))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PlayWindowView()
}
