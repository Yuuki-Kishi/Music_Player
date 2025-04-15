//
//  NotDisplayFolder.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/15.
//

import Foundation
import SwiftData

@Model
final class ReadFolder: Sendable {
    @Attribute(.unique) var id: UUID = UUID()
    var folderPath: String
    var isRead: Bool
    
    init(id: UUID, folderPath: String, isRead: Bool) {
        self.id = id
        self.folderPath = folderPath
        self.isRead = isRead
    }
    
    init(folderPath: String, isRead: Bool) {
        self.folderPath = folderPath
        self.isRead = isRead
    }
}
