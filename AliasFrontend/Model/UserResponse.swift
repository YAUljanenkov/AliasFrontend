//
//  UserResponse.swift
//  AliasFrontend
//
//  Created by Ярослав Ульяненков on 21.05.2023.
//

import Foundation

struct UserResponse: Codable {
    let email: String?
    let id: String
    let name: String?
    let passwordHash: String?
}
