//
//  LoginResponse.swift
//  AliasFrontend
//
//  Created by Ярослав Ульяненков on 21.05.2023.
//

import Foundation

struct LoginResponse: Codable {
    let value: String
    let id: String
    let user: UserResponse
}
