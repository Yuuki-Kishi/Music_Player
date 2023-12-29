//
//  playingMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct playingMusic: View {
    @State var progressValue = Singleton.shared.progressValue
    var body: some View {
        ZStack {
            VStack {
                ProgressView(value: progressValue, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.purple))
                HStack {
                    VStack {
                        Text("曲名")
                            .font(.system(size: 20.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Text("アーティスト名")
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("アルバム名")
                                .font(.system(size: 12.5))
                                .frame(maxWidth: .infinity,alignment: .leading)
                        }
                    }
                    Button(action: {
                        
                    }){
                        Image(systemName: "play.fill")
                    }
                    .foregroundStyle(.primary)
                    .font(.system(size: 25))
                    Button(action: {
                        
                    }){
                        Image(systemName: "forward.fill")
                    }
                    .foregroundStyle(.primary)
                    .font(.system(size: 25.0))
                }
            }
        }.padding(.bottom)
    }
}

#Preview {
    playingMusic()
}
