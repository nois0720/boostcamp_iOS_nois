//
//  ImageBoardAPI.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

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

enum FetchPhotoResult {
    case Success(UIImage)
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

struct ImageBoardAPI {
    
    //Mark: -static members
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    static func signupURL() -> URL { return imageBoardURL(method: .Signup, parameters: nil) }
    static func loginURL() -> URL { return imageBoardURL(method: .Login, parameters: nil) }
    static func imageURL() -> URL { return imageBoardURL(method: .GetBoardContents, parameters: nil) }
    static func postURL() -> URL { return imageBoardURL(method: .PostImage, parameters: nil) }
    
    static func dateFormatStringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    //Mark: -private members
    private static let baseURL = "https://ios-api.boostcamp.connect.or.kr"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "MM dd, yyyy at HH:mm:ss 'on'"
        
        return formatter
    }()
    
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
}
