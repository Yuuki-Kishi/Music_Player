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
    
    func insertFirst(music: Music) async -> [Music] {
        let willPlayMusicDatas = await readWillPlayMusicDatas()
        await deleteAllWillPlayMusicData()
        await createWillPlayMusicData(music: music, index: 0)
        for willPlayMusicData in willPlayMusicDatas {
            await createWillPlayMusicData(music: willPlayMusicData.music, index: willPlayMusicData.index + 1)
        }
        return await readWillPlayMusics()
    }
    
    func resaveWillPlayMusicDatas(musics: [Music]) async {
        await deleteAllWillPlayMusicData()
        for music in musics {
            let index = musics.firstIndex(where: {$0.filePath == music.filePath})!
            await createWillPlayMusicData(music: music, index: index)
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
