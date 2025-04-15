//
//  AddPlaylistViewCell.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/10.
//

import SwiftUI

struct AddPlaylistViewCell: View {
    @ObservedObject var pathDataStore: PathDataStore
    @State var playlist: Playlist
    @State var music: Music
    @State private var isShowAlert: Bool = false
    @State var pathArray: AddPlaylistView.PathArray
    
    var body: some View {
        HStack {
            Image(systemName: "music.note.list")
                .font(.system(size: 30.0))
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
        .alert("追加完了", isPresented: $isShowAlert, actions: {
            Button(action: {
                added()
            }, label: {
                Text("OK")
            })
        }, message: {
            Text("プレイリストに追加しました。")
        })
        .onTapGesture {
            tapped(playlistFilePath: playlist.filePath)
        }
    }
    func tapped(playlistFilePath: String) {
        guard PlaylistRepository.addPlaylistMusic(playlistFilePath: playlistFilePath, musicFilePath: music.filePath) else { return }
        isShowAlert = true
    }
    func added() {
        switch pathArray {
        case .music:
            pathDataStore.musicViewNavigationPath.removeLast()
        case .artist:
            pathDataStore.artistViewNavigationPath.removeLast()
        case .album:
            pathDataStore.albumViewNavigationPath.removeLast()
        case .folder:
            pathDataStore.folderViewNavigationPath.removeLast()
        case .play:
            pathDataStore.playViewNavigationPath.removeLast()
        }
    }
}

#Preview {
    AddPlaylistViewCell(pathDataStore: PathDataStore.shared, playlist: Playlist(), music: Music(), pathArray: .music)
}
