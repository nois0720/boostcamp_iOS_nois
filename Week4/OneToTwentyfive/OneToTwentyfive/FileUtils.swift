//
//  FileManagerSingleton.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 25..
//  Copyright © 2017년 Nois. All rights reserved.
//

import Foundation

class FileUtils {
    
    private static var fileManager: FileManager = {
        return FileManager.default
    } ()
    
    private init() {
        
    }
    
    class func write(fileName: String, dataString: String) {
        let path = "/Applications/\(fileName)"
        let data = dataString.data(using: .utf8)
        
        fileManager.createFile(atPath: path, contents: data, attributes: nil)
    }
    
    class func read(fileName: String) {
        let path = "/Applications/\(fileName)"
        
        guard fileManager.fileExists(atPath: path) else {
            print("File not found")
            return
        }
        
        guard fileManager.isReadableFile(atPath: path) else {
            print("file is not readable")
            return
        }
        
        let data = fileManager.contents(atPath: path)
        let dataString = String(data: data!, encoding: .utf8)
        
        guard dataString != nil else {
            return
        }
        
        print(dataString!)
        
    }
    
}
