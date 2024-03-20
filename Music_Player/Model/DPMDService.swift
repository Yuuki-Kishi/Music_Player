//
//  DPMDService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/18.
//

import Foundation
import SwiftData

class DPMDPersistance {
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([DPMD.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("error create sharedModelContainer: \(error)")
        }
    }()
    
}

actor DPMDPersistanceActor: ModelActor {
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

final class DPMDService {
    static let shared = DPMDService()
    lazy var actor = {
        return DPMDPersistanceActor(modelContainer: DPMDPersistance.sharedModelContainer)
    }()
    
    func createDPMD(music: Music) async {
        let DPMD = DPMD(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
        await actor.insert(DPMD)
    }
    
    func deleteDPMD(DPMD: DPMD) async {
        await actor.delete(DPMD)
    }
    
    func getAllDPMDs() async -> [DPMD] {
        let predicate = #Predicate<DPMD> { todo in
            return true
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
}
