//
//  ImageBoardAPI.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import Foundation

enum Method: String {
    case GetBoardContents = ""
    case Signup = "/user"
    case Login = "/login"
    case PostImage = "/image"
    case ModifyImage, DeleteImage = "/image/:article_id:"
}

enum ImagesResult {
    case Success([Photo])
    case Failure(Error)
}

enum UserResult {
    case Success(User)
    case Failure(Error)
}

enum JsonResult {
    case Success(Data)
    case Failure(Error)
}

enum UploadResult {
    case Success(Photo)
    case Failure(Error)
}

enum APIError: Error {
    case InvalidJSONData
    case EmailDuplicated
    case NonexistentEmail
    case WrongPassword
    case UnknownErrorMessage
    case UserParsingError
    case PhotoParsingError
}

let formatter = DateFormatter()

let dateString = formatter.string(from: Date())

struct ImageBoardAPI {
    
    //Mark: -private static properties
    private static let baseURL = "https://ios-api.boostcamp.connect.or.kr"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "MM dd, yyyy at HH:mm:ss 'on'"
        
        return formatter
    }()
    
    
    //Mark: -static functions
    static func signupURL() -> URL {
        return imageBoardURL(method: .Signup, parameters: nil)
    }
    
    static func loginURL() -> URL {
        return imageBoardURL(method: .Login, parameters: nil)
    }
    
    static func imageURL() -> URL {
        return imageBoardURL(method: .GetBoardContents, parameters: nil)
    }
    
    static func postURL() -> URL {
        return imageBoardURL(method: .PostImage, parameters: nil)
    }
    
//    static func JSONDataFromPhoto(photo: Photo) -> ImagesResult {
//        do {
//            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
//            
//            guard let imageJsonList = jsonObject as? [[String : AnyObject]] else {
//                return .Failure(APIError.InvalidJSONData)
//            }
//            
//            var images = [Photo]()
//            
//            for imageJson in imageJsonList {
//                if let image = imageFromJSONObject(json: imageJson) {
//                    images.append(image)
//                }
//            }
//            
//            return .Success(images)
//        } catch let error {
//            return .Failure(error)
//        }
//    }
    
    static func photosFromJSONData(data: Data) -> ImagesResult {
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
    
    static func userFromJsonData(data: Data) -> UserResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let userJson = jsonObject as? [String : AnyObject] else {
                return .Failure(APIError.InvalidJSONData)
            }
            
            guard userJson["error"] == nil else {
                let errorMessage = userJson["error"] as! String
                switch errorMessage {
                case "no user":
                    return .Failure(APIError.NonexistentEmail)
                case "email duplication":
                    return .Failure(APIError.EmailDuplicated)
                case "wrong password":
                    return .Failure(APIError.WrongPassword)
                default :
                    return .Failure(APIError.UnknownErrorMessage)
                }
            }
            
            guard let user = userFromJsonObject(json: userJson) else {
                return .Failure(APIError.UserParsingError)
            }
            
            return .Success(user)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    static func photoFromJsonData(data: Data) -> UploadResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let photoJson = jsonObject as? [String : AnyObject] else {
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
    
    static func dateFormatStringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    
    //Mark: -private static functions
    private static func imageBoardURL(method: Method, parameters: [String : String]?) -> URL {
        let url = "\(baseURL)\(method.rawValue)"
        var components = URLComponents(string: url)!
        
        var queryItems = [URLQueryItem]()
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        if(queryItems.count > 0) {
            components.queryItems = queryItems
        }
        
        return components.url!
    }
    
    private static func photoFromJsonObject(json: [String : AnyObject]) -> Photo? {
        /* response json format:
         "_id": <String : 게시글 id>
         "created_at": <Integer : 작성일시 타임스템프>
         "thumb_image_url": <String : 섬네일 이미지 하위주소
         "image_url": <String : 이미지 하위주소>
         "author_nickname": <String : 사용자 별명>
         "author": <String : 작성자 고유 id>
         "image_desc": <String : 이미지 설명>
         "image_title": <String : 이미지 제목> */
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
        
        let imageURL = ImageBoardAPI.imageBoardURL(method: .GetBoardContents, parameters: nil)
        let remoteURL = "\(imageURL)\(remoteSubURL)"
        let thumbRemoteURL = "\(imageURL)\(thumbRemoteSubURL)"
        let dateCreated = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        return Photo(id: id, dateCreated: dateCreated, thumbRemoteURL: thumbRemoteURL, remoteURL: remoteURL, nickname: nickname, author: author, title: title, desc: desc)
    }
    
    private static func userFromJsonObject(json: [String : AnyObject]) -> User? {
        guard let email = json["email"] as? String,
            let password = json["password"] as? String,
            let nickname = json["nickname"] as? String else {
                return nil
        }
        
        return User(email: email, password: password, nickname: nickname)
    }
}
