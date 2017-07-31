//
//  ImageBoardAPI.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import Foundation

enum Method: String {
    case GetBoardContents = "/"
    case Signup = "/user"
    case Login = "/login"
    case PostImage, ModifyImage, DeleteImage = "/image"
}

enum UserResult {
    case Success(User)
    case Failure(Error)
}

enum ImageBoardError: Error {
    case InvalidJSONData
    case EmailDuplicated
    case NonexistentEmail
    case WrongPassword
    case UnknownErrorMessage
    case UserParsingError
}

struct ImageBoardAPI {
    private static let baseURL = "https://ios-api.boostcamp.connect.or.kr"
    
    static func signupURL() -> URL {
        return imageBoardURL(method: .Signup, parameters: nil)
    }
    
    static func loginURL() -> URL {
        return imageBoardURL(method: .Login, parameters: nil)
    }
    
    static func imageBoardURL(method: Method, parameters: [String : String]?) -> URL {
        let url = "\(baseURL)\(method.rawValue)"
        
        var components = URLComponents(string: url)!
        
        var queryItems = [URLQueryItem]()
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func userFromJsonData(data: Data) -> UserResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let userJson = jsonObject as? [String : AnyObject] else {
                return .Failure(ImageBoardError.InvalidJSONData)
            }
            
            guard userJson["error"] == nil else {
                let errorMessage = userJson["error"] as! String
                switch errorMessage {
                case "no user":
                    return .Failure(ImageBoardError.NonexistentEmail)
                case "email duplication":
                    return .Failure(ImageBoardError.EmailDuplicated)
                case "wrong password":
                    return .Failure(ImageBoardError.WrongPassword)
                default :
                    return .Failure(ImageBoardError.UnknownErrorMessage)
                }
            }
            
            guard let user = userFromJsonObject(json: userJson) else {
                return .Failure(ImageBoardError.UserParsingError)
            }
            
            return .Success(user)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    static func userFromJsonObject(json: [String : AnyObject]) -> User? {
        guard let email = json["email"] as? String,
            let password = json["password"] as? String,
            let nickname = json["nickname"] as? String else {
                return nil
        }
        
        return User(email: email, password: password, nickname: nickname)
    }
}
