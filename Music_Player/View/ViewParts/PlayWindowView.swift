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
        ZStack {
            Rectangle()
                .foregroundStyle(Color(UIColor.systemGray6))
                .frame(height: 60)
            VStack {
                ProgressView(value: playDataStore.seekPosition, total: playDataStore.playingMusic?.musicLength ?? 300)
                    .progressViewStyle(LinearProgressViewStyle(tint: .accent))
                Spacer()
            }
            .padding(.horizontal)
            HStack {
                if playDataStore.playingMusic == nil {
                    Text("再生停止中")
                        .font(.system(size: 20.0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    VStack {
                        Text(playDataStore.playingMusic?.musicName ?? "不明な曲")
                            .lineLimit(1)
                            .font(.system(size: 20.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text(playDataStore.playingMusic?.artistName ?? "不明なアーティスト")
                                .lineLimit(1)
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(playDataStore.playingMusic?.albumName ?? "不明なアルバム")
                                .lineLimit(1)
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity,alignment: .leading)
                        }
                    }
                }
                Spacer(minLength: 100)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            HStack {
                Button(action: {
                    viewDataStore.isShowPlayView = true
                }, label: {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                })
                Button(action: {
                    playButtonAction()
                }, label: {
                    playButtonIcon()
                })
                .font(.system(size: 25.0))
                Button(action: {
                    playDataStore.moveNextMusic()
                }, label: {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 25.0))
                        .padding(.vertical, 10)
                })
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
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
                .padding(10)
        } else {
            Image(systemName: "play.fill")
                .padding(10)
        }
    }
}

#Preview {
    PlayWindowView()
}
