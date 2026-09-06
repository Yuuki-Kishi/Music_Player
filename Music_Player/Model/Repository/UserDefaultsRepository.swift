//
//  UserDefaultsRepository.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2025/04/10.
//

import Foundation

class UserDefaultsRepository {
    static let userDefaults = UserDefaults.standard
    
    //save
    static func save<T>(key: String, value: T) {
        userDefaults.set(value, forKey: key)
    }
    
    //load
    static func load<T>(key: String, as type: T.Type) -> T? {
        return userDefaults.value(forKey: key) as? T
    }
 }
