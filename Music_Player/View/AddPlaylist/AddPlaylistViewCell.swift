//
//  AddPlaylistViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/10.
//

import SwiftUI

struct AddPlaylistViewCell: View {
//    private let playGroup: PlayDataStore.PlayGroup
    private let music: Music?
    private let playlist: Playlist
    @State private var isShowAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    init(music: Music?, playlist: Playlist) {
        self.music = music
        self.playlist = playlist
    }
    
    var body: some View {
        HStack {
            Image(systemName: "music.note.list")
                .font(.system(size: 30.0))
                .foregroundStyle(.accent)
                .background(
                    RoundedRectangle(cornerRadius: 5.0)
                        .foregroundStyle(Color(UIColor.systemGray5))
                        .frame(width: 50, height: 50)
                )
                .frame(width: 40, height: 40)
            Text(playlist.playlistName)
                .font(.system(size: 20.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text(String(playlist.musicCount) + "曲")
                .font(.system(size: 15.0))
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .alert("\(playlist.playlistName)AddPlaylistViewCell.Alert.title", isPresented: $isShowAlert) {
            OKButton {
                dismiss()
            }
        } message: {
            Text("AddPlaylistViewCell.Alert.message")
        }
        .onTapGesture {
            tapped()
        }
    }
    func tapped() {
        guard let filePath = music?.filePath else { return }
        guard PlaylistRepository.addPlaylistMusic(playlistFilePath: playlist.filePath, musicFilePath: filePath) else { return }
        isShowAlert = true
    }
}

#Preview {
    AddPlaylistViewCell(music: Music(), playlist: Playlist())
}
