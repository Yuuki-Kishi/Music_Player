//
//  WillPlayViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/06.
//

import SwiftUI

struct WillPlayViewCell: View {
    @StateObject var willPlayDataStore = WillPlayDataStore.shared
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
        guard let index = willPlayDataStore.willPlayMusicArray.firstIndex(of: music) else { return }
        let skipMusicFilePaths = willPlayDataStore.willPlayMusicArray.prefix(index - 1).map { $0.filePath }
        guard WillPlayRepository.removeWillPlay(filePaths: skipMusicFilePaths) else { return }
        guard PlayedRepository.addPlayed(newMusicFilePaths: skipMusicFilePaths) else { return }
        Task {
            willPlayDataStore.willPlayMusicArray = await WillPlayRepository.getWillPlay()
        }
    }
}

#Preview {
    WillPlayViewCell(music: Music())
}
