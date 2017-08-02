//
//  ImageBoardAPI_Image.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 8. 2..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

//MARK: - 썸네일 이미지 받아오기, 이미지 포스트 하기
extension ImageBoardAPI {
    /* 게시판 리스트 받아오기 */
    static func fetchBoardPhotoItems(completion: @escaping (PhotosResult) -> Void) {
        let url = ImageBoardAPI.imageURL()
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("status: \(httpResponse.statusCode)")
                print("header Fields: \(httpResponse.allHeaderFields)")
            }
            
            let result = self.photosResultFromResponseData(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    /* 썸네일 이미지 받아오기 */
    static func fetchThumbnailPhotoForImage(photo: Photo, completion: @escaping (FetchPhotoResult) -> Void) {
        if let image = photo.image {
            completion(.success(image))
            return
        }
        
        let photoURL = photo.thumbRemoteURL
        guard let url = URL(string: photoURL) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = ImageBoardAPI.session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.fetchPhotoResultFromResponseData(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    /* 이미지 포스팅하기 */
    static func postImage(photo: PhotoForUpload, completion: @escaping (PhotoResult) -> Void) {
        guard let image = photo.image,
            let imageData = UIImageJPEGRepresentation(image, 0.5) else {
                return
        }
        
        let dictionaryForJson: [String : String] = ["image_title": "\(photo.title)",
            "image_desc":"\(photo.desc)"]
        
        let url = ImageBoardAPI.postURL()
        
        var request = URLRequest(url: url)
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = createMimeTypeBody(parameters: dictionaryForJson, boundary: boundary, data: imageData, mimeType: "image/jpg", filename: "hello.jpg")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.photoResultFromResponseData(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    /* 이미지 삭제하기 */
    static func deleteImage(id: String, completion: @escaping (PhotoResult) -> Void) {
        let baseUrl = ImageBoardAPI.deleteURL(articleId: id)
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "DELETE"
        print(baseUrl)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.photoResultFromResponseData(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    /* 이미지 수정하기 */
    static func editImage(photoId: String, photo: PhotoForUpload, completion: @escaping (PhotoResult) -> Void) {
        guard let image = photo.image,
            let imageData = UIImageJPEGRepresentation(image, 1) else {
                return
        }
        
        let dictionaryForJson: [String : String] = ["image_title": "\(photo.title)",
            "image_desc":"\(photo.desc)"]
        
        let url = ImageBoardAPI.putURL(articleId: photoId)
        
        var request = URLRequest(url: url)
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = createMimeTypeBody(parameters: dictionaryForJson, boundary: boundary, data: imageData, mimeType: "image/jpg", filename: "hello.jpg")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.photoResultFromEditResponseData(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    private static func photosResultFromResponseData(data : Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return photosResultFromJSONData(data: jsonData)
    }
    
    private static func photosResultFromJSONData(data: Data) -> PhotosResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let photoJsonList = jsonObject as? [[String : AnyObject]] else {
                return .failure(APIError.invalidJSONData)
            }
            
            var photos = [Photo]()
            
            for photoJson in photoJsonList {
                if let photo = photoObjectFromJsonObject(json: photoJson) {
                    photos.append(photo)
                }
            }
            
            return .success(photos)
        } catch let error {
            return .failure(error)
        }
    }
    
    private static func photoResultFromResponseData(data: Data?, error: Error?) -> PhotoResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
            print(jsonString)
        }
        
        return photoResultFromResponseJson(data: jsonData)
    }
    
    private static func photoResultFromEditResponseData(data: Data?, error: Error?) -> PhotoResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
            print(jsonString)
        }
        
        return photoFromEditResponseJson(data: jsonData)
    }
    
    private static func photoFromEditResponseJson(data: Data) -> PhotoResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let photoJson = jsonObject as? [String : AnyObject] else {
                    return .failure(APIError.invalidJSONData)
            }
            
            guard photoJson["error"] == nil else {
                let errorMessage = photoJson["error"] as! String
                switch errorMessage {
                default :
                    return .failure(APIError.unknownErrorMessage)
                }
            }
            
            guard let photo = photoObjectFromJsonObject(json: photoJson) else {
                return .failure(APIError.userParsingError)
            }
            
            return .success(photo)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    private static func photoResultFromResponseJson(data: Data) -> PhotoResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            // 질문. response json이 [String : AnyObject] 배열 형태인데, element가 한 개임. 이런 경우 어떻게 처리해야..?
            guard let photoJsons = jsonObject as? [[String : AnyObject]],
                let photoJson = photoJsons.first else {
                    return .failure(APIError.invalidJSONData)
            }
            
            guard photoJson["error"] == nil else {
                let errorMessage = photoJson["error"] as! String
                switch errorMessage {
                default :
                    return .failure(APIError.unknownErrorMessage)
                }
            }
            
            guard let photo = photoObjectFromJsonObject(json: photoJson) else {
                return .failure(APIError.userParsingError)
            }
            
            return .success(photo)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    private static func fetchPhotoResultFromResponseData(data: Data?, error: Error?) -> FetchPhotoResult {
        guard let imageData = data else {
            return .failure(error!)
        }
        
        guard let image = UIImage(data: imageData) else {
            return .failure(APIError.unknownErrorMessage)
        }
        
        return .success(image)
    }
    
    private static func photoObjectFromJsonObject(json: [String : AnyObject]) -> Photo? {
        guard let id = json["_id"] as? String,
            let timestamp = json["created_at"] as? Int,
            let thumbRemoteSubURL = json["thumb_image_url"] as? String,
            let remoteSubURL = json["image_url"] as? String,
            let nickname = json["author_nickname"] as? String,
            let authorId = json["author"] as? String,
            let desc = json["image_desc"] as? String,
            let title = json["image_title"] as? String else {
                return nil
        }
        
        let imageURL = ImageBoardAPI.imageURL()
        let remoteURL = "\(imageURL)\(remoteSubURL)"
        let thumbRemoteURL = "\(imageURL)\(thumbRemoteSubURL)"
        let dateCreated = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        return Photo(id: id, dateCreated: dateCreated, thumbRemoteURL: thumbRemoteURL, remoteURL: remoteURL, nickname: nickname, authorId: authorId, title: title, desc: desc)
    }
    
    private static func createMimeTypeBody(parameters: [String: String],
                                   boundary: String,
                                   data: Data,
                                   mimeType: String,
                                   filename: String) -> Data {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"image_data\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}
