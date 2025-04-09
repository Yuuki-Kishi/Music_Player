//
//  playingMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct PlayWindowView: View {
    @StateObject var musicDataStore = MusicDataStore.shared
    @StateObject var viewDataStore = ViewDataStore.shared
    @StateObject var playDataStore = PlayDataStore.shared
    
    var body: some View {
        VStack {
            ProgressView(value: playDataStore.seekPosition, total: playDataStore.playingMusic?.musicLength ?? 300)
                .progressViewStyle(LinearProgressViewStyle(tint: .accent))
                .padding(.horizontal)
            ZStack {
                HStack {
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer(minLength: 100)
                }
                .frame(height: 20)
                HStack {
                    Button(action: {
                        viewDataStore.isShowPlayView = true
                    }, label: {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .frame(maxWidth: .infinity, maxHeight: 20)
                    })
                    Button(action: {
                        playButtonAction()
                    }, label: {
                        playButtonIcon()
                    })
                    .font(.system(size: 25.0))
                    .foregroundStyle(.primary)
                    Button(action: {
                        playDataStore.moveNextMusic()
                    }, label: {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 25.0))
                    })
                    .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)
        }
        .background(Color(UIColor.systemGray5))
    }
    func randomPlay() {
        guard let music = musicDataStore.musicArray.randomElement() else { return }
        playDataStore.musicChoosed(music: music)
        playDataStore.setNextMusics(musicFilePaths: musicDataStore.musicArray.map { $0.filePath })
    }
    func playButtonAction() {
        if playDataStore.playingMusic == nil {
            randomPlay()
        } else {
            if playDataStore.isPlaying {
                playDataStore.pause()
            } else {
                playDataStore.play()
            }
        }
    }
    func playButtonIcon() -> some View {
        if playDataStore.isPlaying {
            Image(systemName: "pause.fill")
                .padding(14)
        } else {
            Image(systemName: "play.fill")
                .padding(14)
        }
    }
}

#Preview {
    PlayWindowView()
}
