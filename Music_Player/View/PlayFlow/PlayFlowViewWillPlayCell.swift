//
//  WillPlayViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/06.
//

import SwiftUI

struct PlayFlowViewWillPlayCell: View {
    @ObservedObject var willPlayDataStore: WillPlayDataStore
    @ObservedObject var playedDataStore: PlayedDataStore
    @ObservedObject var playDataStore: PlayDataStore
    @State var music: Music
    
    var body: some View {
        HStack {
            VStack {
                Text(music.musicName)
                    .lineLimit(1)
                    .font(.system(size: 20.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(music.artistName)
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.gray)
                    Text(music.albumName)
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(.gray)
                }
            }
            Text(secToMin(second:music.musicLength))
                .foregroundStyle(Color.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            tapped()
        }
    }
    func secToMin(second: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if second < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: second)!
    }
    func tapped() {
        Task {
            guard let previousMusicFilePath = playDataStore.playingMusic?.filePath else { return }
            guard PlayedRepository.addPlayed(newMusicFilePath: previousMusicFilePath) else { return }
            guard let index = willPlayDataStore.willPlayMusicArray.firstIndex(where: { $0.filePath == music.filePath }) else { return }
            let skipMusicFilePaths = willPlayDataStore.willPlayMusicArray.prefix(index).map { $0.filePath }
            guard WillPlayRepository.removeWillPlays(filePaths: skipMusicFilePaths) else { return }
            guard PlayedRepository.addPlayeds(newMusicFilePaths: skipMusicFilePaths) else { return }
            guard WillPlayRepository.removeWillPlay(filePath: music.filePath) else { return }
            await playDataStore.moveChoosedMusic(music: music)
            willPlayDataStore.willPlayMusicArray = await WillPlayRepository.getWillPlay()
            playedDataStore.playedMusicArray = await PlayedRepository.getPlayed()
        }
    }
}

#Preview {
    PlayFlowViewWillPlayCell(willPlayDataStore: WillPlayDataStore.shared, playedDataStore: PlayedDataStore.shared, playDataStore: PlayDataStore.shared, music: Music())
}
