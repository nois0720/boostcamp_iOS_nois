//
//  RecordStore.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 25..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class RecordStore {
    
    var allRecordItems = [RecordItem]()
    
    func createRecordItem(nickName: String, record: String) -> RecordItem {
        let newRecordItem = RecordItem(nickName: nickName, record: record)
        
        allRecordItems.append(newRecordItem)
        
        return newRecordItem
    }
    
    func removeRecordItem(recordItem: RecordItem) {
        guard let index = allRecordItems.index(of: recordItem) else {
            return
        }
        
        allRecordItems.remove(at: index)
    }
    
    func removeAllItem() {
        allRecordItems = []
    }
    
    init() {
        createRecordItem(nickName: "aaa", record: "asdfasdfa")
    }
    
}
