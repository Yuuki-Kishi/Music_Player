//
//  FileManager.swift
//  Music_Player
//
//  Created by 岸　優樹 on 2024/02/05.
//

import Foundation

class FileManager {
    let fileManager = FileManager.default
    
    let directories = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = directories.first
    let fileURL = documentDirectory!.appendingPathComponent("explain.txt")
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let filePath = documentsPath + "/explain.txt"
    let content = "ここに書いた説明を読めるようにするために、このファイルを「このiPhone内」のフォルダの中に保存できるようにしたい。"
    if !fileManager.fileExists(atPath: filePath) {
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    do {
        let data = try fileManager.contentsOfDirectory(atPath: documentsPath)
        print("data:", data)
    } catch {
        print(error)
    }
}
