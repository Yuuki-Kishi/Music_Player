//
//  PlayedViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/06.
//

import SwiftUI

struct PlayFlowViewPlayedCell: View {
    @StateObject var willPlayDataStore = WillPlayDataStore.shared
    @StateObject var playDataStore = PlayDataStore.shared
    @StateObject var playedDataStore = PlayedDataStore.shared
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
            guard let playingMusicFilePath = playDataStore.playingMusic?.filePath else { return }
            guard WillPlayRepository.insertWillPlay(newMusicFilePath: playingMusicFilePath, at: 0) else { return }
            guard let index = playedDataStore.playedMusicArray.firstIndex(of: music) else { return }
            let suffix = playedDataStore.playedMusicArray.count - index - 1
            let backMusicFilePaths = playedDataStore.playedMusicArray.suffix(suffix).map { $0.filePath }
            guard PlayedRepository.removePlayeds(filePaths: backMusicFilePaths) else { return }
            guard WillPlayRepository.insertWillPlays(newMusicFilePaths: backMusicFilePaths, at: 0) else { return }
            guard PlayedRepository.removePlayed(filePath: music.filePath)  else { return }
            playDataStore.moveChoosedMusic(music: music)
            willPlayDataStore.willPlayMusicArray = await WillPlayRepository.getWillPlay()
            playedDataStore.playedMusicArray = await PlayedRepository.getPlayed()
        }
    }
}

#Preview {
    PlayFlowViewPlayedCell(music: Music())
}
