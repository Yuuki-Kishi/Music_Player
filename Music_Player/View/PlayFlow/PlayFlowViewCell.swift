//
//  PlayFlowViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/08/08.
//

import SwiftUI

struct PlayFlowViewCell: View {
    @EnvironmentObject private var playFlowDataStore: PlayFlowDataStore
    private let music: Music
    private let cellType: CellTypeEnum
    
    enum CellTypeEnum {
        case playNext, playBuck
    }
    
    init(music: Music, cellType: CellTypeEnum) {
        self.music = music
        self.cellType = cellType
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(music.musicName)
                    .lineLimit(1)
                    .font(.system(size: 20.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(music.artistAndAlbumName)
                    .lineLimit(1)
                    .font(.system(size: 12.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.secondary)
            }
            Text(music.musicLength.formattedTime)
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            tapped()
        }
    }
    func tapped() {
        switch cellType {
        case .playNext:
            Task {
                guard PlayFlowRepository.selectPlayNextMusic(filePath: music.filePath) else { return }
                playFlowDataStore.playNextMusicArray = await PlayFlowRepository.getPlayNextM3U8()
                playFlowDataStore.playBackMusicArray = await PlayFlowRepository.getPlayBackM3U8()
                print("SelectPlayNextSuccessed")
            }
        case .playBuck:
            Task {
                guard PlayFlowRepository.selectPlayBackMusic(filePath: music.filePath) else { return }
                playFlowDataStore.playNextMusicArray = await PlayFlowRepository.getPlayNextM3U8()
                playFlowDataStore.playBackMusicArray = await PlayFlowRepository.getPlayBackM3U8()
                print("SelectPlayBackSuccessed")
            }
        }
    }
}

#Preview {
    PlayFlowViewCell(music: Music(), cellType: .playNext)
}
