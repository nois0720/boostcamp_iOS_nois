//
//  PhotoForUpload.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 8. 2..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class PhotoForUpload {
    let title: String
    let desc: String
    var image: UIImage?
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }
}
