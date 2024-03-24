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
    
    func createDidPlayMusicData(music: Music, index: Int) async {
        let didPlayMusicData = DidPlayMusicData(music: music, index: index)
        await actor.insert(didPlayMusicData)
    }
    
    func readDidPlayMusics() async -> [Music] {
        let predicate = #Predicate<DidPlayMusicData> { DidPlayMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        let didPlayMusicDatas = await actor.get(descriptor) ?? []
        var musics = [Music]()
        for didPlayMusic in didPlayMusicDatas {
            let music = didPlayMusic.music
            musics.append(music)
        }
        return musics
    }
    
    func readDidPlayMusicDatas() async -> [DidPlayMusicData] {
        let predicate = #Predicate<DidPlayMusicData> { DidPlayMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
    
    func updateDidPlayMusic(oldMusic: Music, newMusic: Music) async {
        if let didPlayMusicData = await readDidPlayMusicDatas().first(where: {$0.music.filePath == oldMusic.filePath}) {
            didPlayMusicData.music = newMusic
            await actor.save()
        }
    }
    
    func deleteDidPlayMusicData(music: Music) async {
        if let didPlayMusicData = await readDidPlayMusicDatas().first(where: {$0.music.filePath == music.filePath}) {
            await actor.delete(didPlayMusicData)
        }
    }
    
    func deleteAllDidPlayMusicDatas() async {
        for didPlayMusic in await readDidPlayMusics() {
            await deleteDidPlayMusicData(music: didPlayMusic)
        }
    }
}
