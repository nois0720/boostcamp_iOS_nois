//
//  User.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import Foundation

class User {
    let id: String
    let email: String
    let password: String
    let nickname: String?
    
    init(id: String, email: String, password: String, nickname: String? = nil) {
        self.id = id
        self.email = email
        self.password = password
        self.nickname = nickname
    }
}
