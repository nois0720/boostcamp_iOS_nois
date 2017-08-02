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
    case getBoardContents = ""
    case signup = "/user"
    case login = "/login"
    case image = "/image"
}

enum UserResult {
    case success(User)
    case failure(Error)
}

enum JsonResult {
    case success(Data)
    case failure(Error)
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

enum PhotoResult {
    case success(Photo)
    case failure(Error)
}

enum FetchPhotoResult {
    case success(UIImage)
    case failure(Error)
}

enum APIError: Error {
    case invalidJSONData
    case emailDuplicated
    case nonexistentEmail
    case wrongPassword
    case unknownErrorMessage
    case userParsingError
    case photoParsingError
}

struct ImageBoardAPI {
    
    //Mark: -static members
    static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    static func signupURL() -> URL { return imageBoardURL(method: .signup, parameters: nil) }
    static func loginURL() -> URL { return imageBoardURL(method: .login, parameters: nil) }
    static func imageURL() -> URL { return imageBoardURL(method: .getBoardContents, parameters: nil) }
    static func postURL() -> URL { return imageBoardURL(method: .image, parameters: nil) }
    static func deleteURL(articleId: String) -> URL { return imageBoardArticleURL(method: .image, articleId: articleId) }
    static func putURL(articleId: String) -> URL { return imageBoardArticleURL(method: .image, articleId: articleId) }
    
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
    
    private static func imageBoardArticleURL(method: Method, articleId: String) -> URL {
        let url = "\(baseURL)\(method.rawValue)/\(articleId)"
        let components = URLComponents(string: url)!
        
        return components.url!
    }
}
