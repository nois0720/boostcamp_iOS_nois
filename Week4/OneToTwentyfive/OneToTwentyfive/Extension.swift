//
//  Extension.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 24..
//  Copyright © 2017년 Nois. All rights reserved.
//

import Foundation

extension Array {
    
    func shuffled() -> Array {
        var tempArr: Array = self
        
        for i in 0..<tempArr.count {
            var randomIdx = arc4random_uniform(UInt32(tempArr.count - 1))
            
            while Int(randomIdx) == i {
                randomIdx = arc4random_uniform(UInt32(tempArr.count - 1))
            }
            
            swap(&tempArr[i], &tempArr[Int(randomIdx)])
        }
        
        return tempArr
    }
    
    mutating func shuffle() {
        for i in 0..<self.count {
            var randomIdx = arc4random_uniform(UInt32(self.count - 1))
            
            while Int(randomIdx) == i {
                randomIdx = arc4random_uniform(UInt32(self.count - 1))
            }
            
            swap(&self[i], &self[Int(randomIdx)])
        }
    }
    
}
