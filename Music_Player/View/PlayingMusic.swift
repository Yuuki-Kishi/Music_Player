//
//  playingMusic.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2023/12/29.
//

import SwiftUI

struct PlayingMusic: View {
    @ObservedObject var vm = ViewModel.shaled
    
    var body: some View {
        ZStack {
            VStack {
                ProgressView(value: vm.seekPosition, total: 1)
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
                        vm.isPlay = !vm.isPlay
                    }, label: {
                        if vm.isPlay {
                            Image(systemName: "pause.fill")
                        } else {
                            Image(systemName: "play.fill")
                        }
                    })
                    .font(.system(size: 25.0))
                    .foregroundStyle(.primary)
                    Spacer(minLength: 30)
                    Button(action: {
                        
                    }){
                        Image(systemName: "forward.fill")
                    }
                    .foregroundStyle(.primary)
                    .font(.system(size: 25.0))
                }
            }
            Color.clear.contentShape(Rectangle())
            .frame(maxWidth: .infinity, maxHeight: 20)
            .padding()
            .onTapGesture {
                print("OK")
                vm.showSheet = !vm.showSheet
            }
            .fullScreenCover(isPresented: $vm.showSheet) {
                Playing()
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    PlayingMusic()
}
