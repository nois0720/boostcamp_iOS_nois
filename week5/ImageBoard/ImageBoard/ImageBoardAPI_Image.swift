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
    static func fetchBoardPhotoItems(completion: @escaping (ImagesResult) -> Void) {
        let url = ImageBoardAPI.imageURL()
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
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
    
    /* 썸네일 이미지 받아오기 */
    static func fetchThumbnailPhotoForImage(photo: Photo, completion: @escaping (FetchPhotoResult) -> Void) {
        if let image = photo.image {
            completion(.Success(image))
            return
        }
        
        let photoURL = photo.thumbRemoteURL
        guard let url = URL(string: photoURL) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = ImageBoardAPI.session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processPhotoRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                photo.image = image
            }
            
            completion(result)
        }
        task.resume()
    }
    
    /* 이미지 포스팅하기 */
    static func postImage(photo: PhotoForUpload, completion: @escaping (UploadResult) -> Void) {
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
        request.httpBody = createBody(parameters: dictionaryForJson, boundary: boundary, data: imageData, mimeType: "image/jpg", filename: "hello.jpg")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processUploadRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    private static func processImagesRequest(data : Data?, error: Error?) -> ImagesResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        return photosFromJSONData(data: jsonData)
    }
    
    private static func photosFromJSONData(data: Data) -> ImagesResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let photoJsonList = jsonObject as? [[String : AnyObject]] else {
                return .Failure(APIError.InvalidJSONData)
            }
            
            var photos = [Photo]()
            
            for photoJson in photoJsonList {
                if let photo = photoFromJsonObject(json: photoJson) {
                    photos.append(photo)
                }
            }
            
            return .Success(photos)
        } catch let error {
            return .Failure(error)
        }
    }
    
    private static func processUploadRequest(data: Data?, error: Error?) -> UploadResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
            print(jsonString)
        }
        
        return photoFromJsonData(data: jsonData)
    }
    
    private static func photoFromJsonData(data: Data) -> UploadResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            // 질문. response json이 [String : AnyObject] 배열 형태인데, element가 한 개임. 이런 경우 어떻게 처리해야..?
            guard let photoJsons = jsonObject as? [[String : AnyObject]],
                let photoJson = photoJsons.first else {
                    return .Failure(APIError.InvalidJSONData)
            }
            
            guard photoJson["error"] == nil else {
                let errorMessage = photoJson["error"] as! String
                switch errorMessage {
                default :
                    return .Failure(APIError.UnknownErrorMessage)
                }
            }
            
            guard let photo = photoFromJsonObject(json: photoJson) else {
                return .Failure(APIError.UserParsingError)
            }
            
            return .Success(photo)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private static func processPhotoRequest(data: Data?, error: Error?) -> FetchPhotoResult {
        guard let imageData = data else {
            return .Failure(error!)
        }
        
        guard let image = UIImage(data: imageData) else {
            return .Failure(APIError.UnknownErrorMessage)
        }
        
        return .Success(image)
    }
    
    private static func photoFromJsonObject(json: [String : AnyObject]) -> Photo? {
        guard let id = json["_id"] as? String,
            let timestamp = json["created_at"] as? Int,
            let thumbRemoteSubURL = json["thumb_image_url"] as? String,
            let remoteSubURL = json["image_url"] as? String,
            let nickname = json["author_nickname"] as? String,
            let author = json["author"] as? String,
            let desc = json["image_desc"] as? String,
            let title = json["image_title"] as? String else {
                return nil
        }
        
        let imageURL = ImageBoardAPI.imageURL()
        let remoteURL = "\(imageURL)\(remoteSubURL)"
        let thumbRemoteURL = "\(imageURL)\(thumbRemoteSubURL)"
        let dateCreated = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        return Photo(id: id, dateCreated: dateCreated, thumbRemoteURL: thumbRemoteURL, remoteURL: remoteURL, nickname: nickname, author: author, title: title, desc: desc)
    }
    
    private static func createBody(parameters: [String: String],
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
