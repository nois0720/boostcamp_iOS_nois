//
//  AuthenticationCenter.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class AuthenticationCenter {
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    var currentUser: User?
    
    enum loginResult: Error {
        case Success(User)
        case Failure(Error)
    }
    
    func requestSignup(userInfo: User, completion: @escaping (UserResult) -> Void) {
        //"email" : <String : 이메일주소>, "password" : <String : 암호>, "nickname" : <String : 별명>
        let dictionaryForJson: [String : Any] = ["email": "\(userInfo.email)",
            "password":"\(userInfo.password)",
            "nickname":"\(userInfo.password)"]
        
        let url = ImageBoardAPI.signupURL()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryForJson,
                                                      options: .prettyPrinted) {
            request.httpBody = jsonData
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in

            let result = self.processUserRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    func requestLogin(userInfo: User, completion: @escaping (UserResult) -> Void) {
        let dictionaryForJson: [String : Any] = ["email": "\(userInfo.email)",
            "password":"\(userInfo.password)"]
        
        let url = ImageBoardAPI.loginURL()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryForJson,
                                                      options: .prettyPrinted) {
            request.httpBody = jsonData
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processUserRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    func processUserRequest(data: Data?, error: Error?) -> UserResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
            print(jsonString)
        }
        
        return ImageBoardAPI.userFromJsonData(data: jsonData)
    }
    
}
