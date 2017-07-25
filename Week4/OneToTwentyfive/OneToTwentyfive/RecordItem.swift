//
//  RecordItem.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 25..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class RecordItem: NSObject {
    
    var nickName: String
    let record: String
    let dateCreated: String
    
    init(nickName: String, record: String) {
        self.nickName = nickName
        self.record = record
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.dateCreated = dateFormatter.string(from: date)
        
        super.init()
    }
    
}
