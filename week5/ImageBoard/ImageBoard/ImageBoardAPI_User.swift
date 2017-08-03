//
//  ImageBoardAPI_User.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 8. 2..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

//MARK: -로그인, 회원가입 구현
extension ImageBoardAPI {
    static func requestLogin(loginInfo: UserForAuthentication, completion: @escaping (UserResult) -> Void) {
        let dictionaryForJson: [String : Any] = ["email": "\(loginInfo.email)",
            "password":"\(loginInfo.password)"]
        
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
    
    static func requestSignup(signupInfo: UserForAuthentication, completion: @escaping (UserResult) -> Void) {
        //"email" : <String : 이메일주소>, "password" : <String : 암호>, "nickname" : <String : 별명>
        let dictionaryForJson: [String : Any] = ["email": "\(signupInfo.email)",
            "password":"\(signupInfo.password)",
            "nickname":"\(signupInfo.password)"]
        
        let url = ImageBoardAPI.signupURL()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryForJson,
                                                      options: .prettyPrinted) {
            request.httpBody = jsonData
        }
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processUserRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    private static func processUserRequest(data: Data?, error: Error?) -> UserResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return ImageBoardAPI.userFromJsonData(data: jsonData)
    }
    
    private static func userFromJsonData(data: Data) -> UserResult {
        do {
            let jsonObject: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let userJson = jsonObject as? [String : AnyObject] else {
                return .failure(APIError.invalidJSONData)
            }
            
            guard userJson["error"] == nil else {
                let errorMessage = userJson["error"] as! String
                switch errorMessage {
                case "no user":
                    return .failure(APIError.nonexistentEmail)
                case "email duplication":
                    return .failure(APIError.emailDuplicated)
                case "wrong password":
                    return .failure(APIError.wrongPassword)
                default :
                    return .failure(APIError.unknownErrorMessage)
                }
            }
            
            guard let user = userFromJsonObject(json: userJson) else {
                return .failure(APIError.userParsingError)
            }
            
            return .success(user)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    private static func userFromJsonObject(json: [String : AnyObject]) -> User? {
        guard let id = json["_id"] as? String,
            let email = json["email"] as? String,
            let password = json["password"] as? String,
            let nickname = json["nickname"] as? String else {
                return nil
        }
        
        return User(id: id, email: email, password: password, nickname: nickname)
    }
}
