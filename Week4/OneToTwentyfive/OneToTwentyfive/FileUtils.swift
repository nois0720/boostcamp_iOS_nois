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
    
    private static var filePath: String {
        let url = FileUtils.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return (url!.appendingPathComponent("Data").path)
    }
    
    class func appendItem2Data(item: RecordItem) {
        var items = loadData()
        items.append(item)
        
        NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
    }
    
    class func replaceData(to items: [RecordItem]) {
        NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
    }
    
    class func loadData() -> [RecordItem] {
        guard let items = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [RecordItem] else {
            return []
        }
        
        return items
    }
    
    class func getHighScoreItem() -> RecordItem? {
        let items = loadData().sorted{$0.record < $1.record}
        
        guard items.count > 0 else {
            return nil
        }
        
        return items[0]
    }
}
