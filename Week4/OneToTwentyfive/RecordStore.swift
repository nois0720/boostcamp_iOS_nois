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
    
    func createRecordItem(recordItem: RecordItem) {
        allRecordItems.append(recordItem)
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
    
    func updateDataFromStore() {
        FileUtils.replaceData(to: allRecordItems)
    }
}
