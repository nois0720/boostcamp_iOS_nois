//
//  Extension.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 24..
//  Copyright © 2017년 Nois. All rights reserved.
//

import Foundation

extension Array {
    
    func shuffled<T>(arr: Array<T>) -> Array<T> {
        var tempArr: Array<T> = arr
        
        for i in 0..<tempArr.count {
            var randomIdx = arc4random_uniform(UInt32(tempArr.count - 1))
            
            while Int(randomIdx) == i {
                randomIdx = arc4random_uniform(UInt32(tempArr.count - 1))
            }
            
            swap(&tempArr[i], &tempArr[Int(randomIdx)])
        }
        
        return tempArr
    }
    
}
