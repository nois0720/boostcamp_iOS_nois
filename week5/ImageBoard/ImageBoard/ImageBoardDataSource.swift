//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Yoo Seok Kim on 2017. 7. 31..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class ImageBoardDataSource: NSObject, UITableViewDataSource {
    var photos = [Photo]()
    var originPhotos = [Photo]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ImageBoardCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ImageBoardCell
        
        let photo = photos[indexPath.row]
        cell.updateWithImage(image: photo.image)
        
        return cell
    }
}
