//
//  WPMDService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/20.
//

import Foundation
import SwiftData

final class WillPlayMusicDataService {
    static let shared = WillPlayMusicDataService()
    lazy var actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    func createWillPlayMusicData(music: Music, index: Int) async {
        let willPlayMusicData = WillPlayMusicData(music: music, index: index)
        await actor.insert(willPlayMusicData)
    }
    
    func insertFirst(music: Music) async {
        let willPlayMusics = await readWillPlayMusics()
        await deleteAllWillPlayMusicData()
        await createWillPlayMusicData(music: music, index: 0)
        for willPlayMusic in willPlayMusics {
            await createWillPlayMusicData(music: willPlayMusic, index: willPlayMusics.count + 1)
        }
    }
    
    func readWillPlayMusics() async -> [Music] {
        let predicate = #Predicate<WillPlayMusicData> { WillPlayMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        var willPlayMusicDatas = await actor.get(descriptor) ?? []
        willPlayMusicDatas.sort {$0.index < $1.index}
        var musics = [Music]()
        for willPlayMusicData in willPlayMusicDatas {
            let music = willPlayMusicData.music
            musics.append(music)
        }
        return musics
    }
    
    func readWillPlayMusicDatas() async -> [WillPlayMusicData] {
        let predicate = #Predicate<WillPlayMusicData> { WillPlayMusicData in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
    
    func updateWillPlayMusicData(oldMusic: Music, newMusic: Music) async {
        if let willPlayMusicData = await readWillPlayMusicDatas().first(where: {$0.music.filePath == oldMusic.filePath}) {
            willPlayMusicData.music = newMusic
            await actor.save()
        }
    }
    
    func deleteWillPlayMusicData(music: Music) async {
        if let willPlayMusicData = await readWillPlayMusicDatas().first(where: {$0.music.filePath == music.filePath}) {
            await actor.delete(willPlayMusicData)
        }
    }
    
    func deleteAllWillPlayMusicData() async {
        for willPlayMusic in await readWillPlayMusics() {
            await deleteWillPlayMusicData(music: willPlayMusic)
        }
    }
}
