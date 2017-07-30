//
//  Item.swift
//  Homepwner
//
//  Created by Yoo Seok Kim on 2017. 7. 16..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        guard random else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
            return
        }
        
        let adjectives = ["Fluffy", "Rusty", "Shiny"]
        let nouns = ["Bear", "Spork", "Mac"]
        
        var idx = arc4random_uniform(UInt32(adjectives.count))
        let randomAdjective = adjectives[Int(idx)]

        idx = arc4random_uniform(UInt32(nouns.count))
        let randomNoun = nouns[Int(idx)]
        
        let randomName = "\(randomAdjective) \(randomNoun)"
        let randomValue = Int(arc4random_uniform(100))
        let randomSeiarlNumber = NSUUID().uuidString.components(separatedBy: "-").first!
        
        self.init(name: randomName, serialNumber: randomSeiarlNumber, valueInDollars: randomValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
        self.serialNumber = aDecoder.decodeObject(forKey: "serialNumber") as! String?
        self.dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(valueInDollars, forKey: "valueInDollars")
        aCoder.encode(serialNumber, forKey: "serialNunber")
        aCoder.encode(dateCreated, forKey: "dateCreated")
    }
    
}
