//
//  DPMDService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/18.
//

import Foundation
import SwiftData

final class DidPlayMusicDataService {
    static let shared = DidPlayMusicDataService()
    lazy var actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    func createDidPlayMusicData(music: Music) async {
        let DidPlayMusicData = DidPlayMusicData(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
        await actor.insert(DidPlayMusicData)
    }
    
    func deleteDidPlayMusicData(DidPlayMusicData: DidPlayMusicData) async {
        await actor.delete(DidPlayMusicData)
    }
    
    func getAllDidPlayMusicDatas() async -> [DidPlayMusicData] {
        let predicate = #Predicate<DidPlayMusicData> { DidPlayMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
}
