//
//  DPMDService.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/03/18.
//

import Foundation
import SwiftData

class Persistance {
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

actor PersistanceActor: ModelActor {
    let modelContainer: ModelContainer
    let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: context)
    }
    
    func insert<T:PersistentModel>(_ value:T) {
        do {
            modelContext.insert(value)
            try modelContext.save()
        }catch {
            print("error insert")
        }
    }
    
    func delete<T:PersistentModel>(_ value:T) {
        do {
            modelContext.delete(value)
            try modelContext.save()
        }catch {
            print("error delete")
        }
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

final class TodoService {
    static let shared = TodoService()
    lazy var actor = {
        return PersistanceActor(modelContainer: Persistance.sharedModelContainer)
    }()
    
    func createDPMD(music: Music) async -> DPMD {
        let DPMD = DPMD(musicName: music.musicName, artistName: music.artistName, albumName: music.albumName, editedDate: music.editedDate, fileSize: music.fileSize, musicLength: music.musicLength, filePath: music.filePath)
        await actor.insert(DPMD)
        return DPMD
    }
    
    func deleteTodo(id: UUID) async -> Bool {
        guard let todo = await getTodoById(id: id) else { return false }
        await actor.delete(todo)
        return true
    }
    
    func getAllTodos() async -> [Todo] {
        let predicate = #Predicate<Todo> { todo in
            return true
        }

        let descriptor = FetchDescriptor(predicate: predicate)
        return await actor.get(descriptor) ?? []
    }
}
