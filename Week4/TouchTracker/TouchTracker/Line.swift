//
//  Line.swift
//  TouchTracker
//
//  Created by Yoo Seok Kim on 2017. 7. 23..
//  Copyright © 2017년 Nois. All rights reserved.
//

import Foundation
import CoreGraphics

protocol TestLine {
    func draw()
}

struct Line: TestLine{
    
    var begin = CGPoint.zero
    var end = CGPoint.zero
    
}
