//
//  PlayedViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/06.
//

import SwiftUI

struct PlayFlowViewPlayedCell: View {
    @ObservedObject var playFlowDataStore: PlayFlowDataStore
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
                        .foregroundStyle(.secondary)
                    Text(music.albumName)
                        .lineLimit(1)
                        .font(.system(size: 12.5))
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(.secondary)
                }
            }
            Text(secToMin(second:music.musicLength))
                .foregroundStyle(.secondary)
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
            guard let playingMusicFilePath = playDataStore.playingMusic?.filePath else { return }
            guard WillPlayRepository.insertWillPlay(newMusicFilePath: playingMusicFilePath, at: 0) else { return }
            guard let index = playFlowDataStore.playedMusicArray.firstIndex(where: { $0.filePath == music.filePath }) else { return }
            let suffix = playFlowDataStore.playedMusicArray.count - index - 1
            let backMusicFilePaths = playFlowDataStore.playedMusicArray.suffix(suffix).map { $0.filePath }
            guard PlayedRepository.removePlayeds(filePaths: backMusicFilePaths) else { return }
            guard WillPlayRepository.insertWillPlays(newMusicFilePaths: backMusicFilePaths, at: 0) else { return }
            guard PlayedRepository.removePlayed(filePath: music.filePath)  else { return }
            await playDataStore.moveChoosedMusic(music: music)
            playFlowDataStore.willPlayMusicArray = await WillPlayRepository.getWillPlay()
            playFlowDataStore.playedMusicArray = await PlayedRepository.getPlayed()
        }
    }
}

#Preview {
    PlayFlowViewPlayedCell(playFlowDataStore: PlayFlowDataStore.shared, playDataStore: PlayDataStore.shared, music: Music())
}
