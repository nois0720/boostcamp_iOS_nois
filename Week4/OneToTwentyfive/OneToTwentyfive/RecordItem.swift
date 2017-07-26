//
//  RecordItem.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 25..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class RecordItem: NSObject, NSCoding {
    
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
    
    required init?(coder aDecoder: NSCoder) {
        self.nickName = aDecoder.decodeObject(forKey: "nickName") as? String ?? ""
        self.record = aDecoder.decodeObject(forKey: "record") as? String ?? ""
        self.dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nickName, forKey: "nickName")
        aCoder.encode(record, forKey: "record")
        aCoder.encode(dateCreated, forKey: "dateCreated")
    }
    
}
