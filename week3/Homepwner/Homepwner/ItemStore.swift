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
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
    
}
