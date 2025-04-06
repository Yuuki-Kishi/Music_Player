//
//  MusicInfoView.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/20.
//

import SwiftUI

struct MusicInfoView: View {
    @StateObject var viewDataStore = ViewDataStore.shared
    @State var music: Music
    @State private var isShowAlert = false
    
    var body: some View {
        List {
            HStack {
                Text("曲名")
                Spacer()
                Text(music.musicName)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(Color.gray)
            }
            HStack {
                Text("アーティスト名")
                Spacer()
                Text(music.artistName)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(Color.gray)
            }
            HStack {
                Text("アルバム名")
                Spacer()
                Text(music.albumName)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(Color.gray)
            }
            HStack {
                Text("曲の長さ")
                Spacer()
                Text(secToMin(second: music.musicLength))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(Color.gray)
            }
            HStack {
                Text("ファイルサイズ")
                Spacer()
                Text(music.fileSize)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(Color.gray)
            }
            HStack {
                Text("ファイルパス")
                Spacer()
                let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
                let fullFilePath = directoryPath + "/" + music.filePath
                Text(fullFilePath)
                    .lineLimit(1)
                    .truncationMode(.head)
                    .foregroundStyle(Color.gray)
            }
            .onTapGesture {
                UIPasteboard.general.string = music.filePath
                isShowAlert = true
            }
            .alert("ファイルパスをコピーしました", isPresented: $isShowAlert, actions: {
                Button(action: {}, label: {
                    Text("OK")
                })
            })
        }
        .navigationTitle("曲の情報")
    }
    func secToMin(second: TimeInterval) -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        if second < 3600 { dateFormatter.allowedUnits = [.minute, .second] }
        else { dateFormatter.allowedUnits = [.hour, .minute, .second] }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: second)!
    }
}

#Preview {
    MusicInfoView(music: Music())
}
