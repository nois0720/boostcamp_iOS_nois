//
//  ImageStore.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 31..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class PhotoStore {
    
    enum FetchPhotoResult {
        case Success(UIImage)
        case Failure(Error)
    }
    
    enum FetchPhotoError: Error {
        case ImageCreationError
    }
    
    func fetchBoardPhotoItems(completion: @escaping (ImagesResult) -> Void) {
        let url = ImageBoardAPI.imageURL()
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("status: \(httpResponse.statusCode)")
                print("header Fields: \(httpResponse.allHeaderFields)")
            }
            
            let result = self.processImagesRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    func processImagesRequest(data : Data?, error: Error?) -> ImagesResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return ImageBoardAPI.photosFromJSONData(data: jsonData)
    }
    
    func fetchThumbnailPhotoForImage(photo: Photo, completion: @escaping (FetchPhotoResult) -> Void) {
        if let image = photo.image {
            completion(.Success(image))
            return
        }
        
        let photoURL = photo.thumbRemoteURL
        guard let url = URL(string: photoURL) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processPhotoRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                photo.image = image
            }
            
            completion(result)
        }
        task.resume()
    }
    
    func processPhotoRequest(data: Data?, error: Error?) -> FetchPhotoResult {
        guard let imageData = data else {
            return .Failure(error!)
        }
        
        guard let image = UIImage(data: imageData) else {
            return .Failure(FetchPhotoError.ImageCreationError)
        }
        
        return .Success(image)
    }
    
}
