//
//  Photo.swift
//  Photorama
//
//  Created by Yoo Seok Kim on 2017. 7. 29..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class Photo {
    let title: String
    let photoID: String
    let remoteURL: URL
    let dateTaken: Date
    var image: UIImage?
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}

extension Photo: Equatable {}

func == (lhs: Photo, rhs: Photo) -> Bool {
    return lhs.photoID == rhs.photoID
}
