//
//  Image.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import Foundation

class Image {
    let title: String
    let data: String
    let desc: String?
    
    init(title: String, data: String, desc: String? = nil) {
        self.title = title
        self.data = data
        self.desc = desc
    }
}
