//
//  WPMDService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/20.
//

import Foundation
import SwiftData

class WPMDPersistance {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([WPMD.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("error create sharedModelContainer: \(error)")
        }
    }()
    
}

actor WPMDPersistanceActor: ModelActor {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func insert<T:PersistentModel>(_ value:T) {
        modelContext.insert(value)
    }
    
    func delete<T:PersistentModel>(_ value:T) {
        modelContext.delete(value)
    }
    
    func get<T:PersistentModel>(_ descriptor:FetchDescriptor<T>)->[T]? {
        var fetched:[T]?
        do {
            fetched = try modelContext.fetch(descriptor)
        }catch {
            print("error get")
        }
        return fetched
    }
}

final class WPMDService {
    static let shared = WPMDService()
    lazy var actor = {
        return WPMDPersistanceActor(modelContainer: WPMDPersistance.sharedModelContainer)
    }()
    
    func createDPMD(music: Music) async {
        let WPMD = WPMD(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
        await actor.insert(WPMD)
    }
    
    func deleteDPMD(WPMD: WPMD) async {
        await actor.delete(WPMD)
    }
    
    func getAllDPMDs() async -> [WPMD] {
        let predicate = #Predicate<WPMD> { todo in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
}
