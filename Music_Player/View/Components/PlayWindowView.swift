//
//  playingMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct PlayWindowView: View {
    @EnvironmentObject private var musicDataStore: MusicDataStore
    @EnvironmentObject private var playDataStore: PlayDataStore
    
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
                VStack {
                    Text(musicNameString())
                        .lineLimit(1)
                        .font(.system(size: 20.0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(artistAndAlbumString())
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer(minLength: 100)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            HStack {
                Button {
                    playDataStore.isShowPlayView = true
                } label: {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                Button {
                    playButtonAction()
                } label: {
                    playButtonIcon()
                }
                Button {
                    PlayRepository.moveNextMusic()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 25.0))
                        .padding(.vertical, 10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
    }
    func musicNameString() -> LocalizedStringKey {
        guard let musicName = playDataStore.playingMusic?.musicName else { return "PlayWindowView.musicNameText.playingMusicIsNil.Text" }
        return LocalizedStringKey(musicName)
    }
    func artistAndAlbumString() -> String {
        guard let playingMusic = playDataStore.playingMusic else { return "" }
        return playingMusic.artistName + " - " + playingMusic.albumName
    }
    func playButtonAction() {
        if playDataStore.playingMusic == nil {
            PlayRepository.randomPlay(musics: musicDataStore.musicArray)
        } else {
            if playDataStore.isPlaying {
                PlayRepository.pause()
            } else {
                PlayRepository.play()
            }
        }
    }
    func playButtonIcon() -> some View {
        if playDataStore.isPlaying {
            Image(systemName: "pause.fill")
                .font(.system(size: 25.0))
                .padding(10)
        } else {
            Image(systemName: "play.fill")
                .font(.system(size: 25.0))
                .padding(10)
        }
    }
}

#Preview {
    PlayWindowView()
}
