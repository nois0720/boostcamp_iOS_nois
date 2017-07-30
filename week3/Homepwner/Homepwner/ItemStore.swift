//
//  ItemStore.swift
//  Homepwner
//
//  Created by Yoo Seok Kim on 2017. 7. 16..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentDirectory = documentsDirectories.first!
        documentDirectory.appendPathComponent("items.archive")
        
        return documentDirectory
    }()
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(_ item: Item) {
        guard let index = allItems.index(of: item) else {
            print("해당 아이템이 없습니다.")
            return
        }
        
        allItems.remove(at: index)
        print("아이템 삭제")
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        guard fromIndex != toIndex else {
            return
        }
        
        let movedItem = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        
        allItems.insert(movedItem, at: toIndex)
    }
    
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
    init() {
        guard let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] else {
            return
        }
        
        allItems += archivedItems
    }
    
}
