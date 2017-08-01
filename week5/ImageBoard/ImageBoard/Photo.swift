//
//  Image.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class Photo {
    //        "_id": <String : 게시글 id>,
    //        "created_at": <Integer : 작성일시 타임스템프>, "thumb_image_url": <String : 섬네일 이미지 하위주소 "image_url": <String : 이미지 하위주소>, "author_nickname": <String : 사용자 별명>,
    //        "author": <String : 작성자 고유 id>,
    //        "image_desc": <String : 이미지 설명>,
    //        "image_title": <String : 이미지 제목>,
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

class UploadPhoto {
    let title: String
    let desc: String
    var image: UIImage?
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }
}
