//
//  TeamResponse.swift
//  AliasFrontend
//
//  Created by Мельник Всеволод on 24.05.2023.
//

import Foundation

struct TeamUserResponse: Codable {
    let id: UUID?
    let name: String
}

struct TeamResponse: Codable {
    let id: UUID
    let name: String
    let users: TeamUserResponse
}
