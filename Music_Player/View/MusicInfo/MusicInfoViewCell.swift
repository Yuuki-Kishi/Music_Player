//
//  MusicInfoViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2026/07/30.
//

import SwiftUI

struct MusicInfoViewCell: View {
    private let music: Music?
    private let infoType: InfoTypeEnum
    private let truncationMode: Text.TruncationMode
    
    enum InfoTypeEnum {
        case musicName, artistName, albumName, musicLength, fileSize, filePath
    }
    
    init(music: Music?, infoType: InfoTypeEnum, truncationMode: Text.TruncationMode) {
        self.music = music
        self.infoType = infoType
        self.truncationMode = truncationMode
    }
    
    var body: some View {
        HStack {
            Text(infoTypeString())
            Spacer()
            Text(infoString())
                .lineLimit(1)
                .truncationMode(truncationMode)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }
    func infoTypeString() -> LocalizedStringKey {
        switch infoType {
        case .musicName:
            return "MusicInfoViewCell.infoTypeString.musicName"
        case .artistName:
            return "MusicInfoViewCell.infoTypeString.artistName"
        case .albumName:
            return "MusicInfoViewCell.infoTypeString.albumName"
        case .musicLength:
            return "MusicInfoViewCell.infoTypeString.musicLength"
        case .fileSize:
            return "MusicInfoViewCell.infoTypeString.fileSize"
        case .filePath:
            return "MusicInfoViewCell.infoTypeString.filePath"
        }
    }
    func infoString() -> String {
        switch infoType {
        case .musicName:
            return music?.musicName ?? "----"
        case .artistName:
            return music?.artistName ?? "----"
        case .albumName:
            return music?.albumName ?? "----"
        case .musicLength:
            return music?.musicLength.formattedTime ?? "----"
        case .fileSize:
            return fileSizeString() ?? "----"
        case .filePath:
            return music?.filePath ?? "----"
        }
    }
    func fileSizeString() -> String? {
        guard let fileSize = music?.fileSize, let fileSize = Int64(exactly: fileSize) else { return nil }
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }
}

#Preview {
    MusicInfoViewCell(music: Music(), infoType: .musicName, truncationMode: .head)
}
