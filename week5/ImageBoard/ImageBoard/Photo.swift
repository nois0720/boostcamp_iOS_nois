//
//  Image.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class Photo {
    let id: String
    let dateCreated: Date
    let thumbRemoteURL: String
    let remoteURL: String
    let nickname: String
    let author: String
    let title: String
    let desc: String
    var image: UIImage?
    
    init(id: String, dateCreated: Date, thumbRemoteURL: String, remoteURL: String,
         nickname: String, author: String, title: String, desc: String) {
        self.id = id
        self.dateCreated = dateCreated
        self.thumbRemoteURL = thumbRemoteURL
        self.remoteURL = remoteURL
        self.nickname = nickname
        self.author = author
        self.title = title
        self.desc = desc
    }
}

extension Photo: Equatable {}

func == (lhs: Photo, rhs: Photo) -> Bool {
    return lhs.id == rhs.id
}
