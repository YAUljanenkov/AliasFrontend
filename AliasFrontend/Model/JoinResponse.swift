//
//  JoinResponse.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 24.05.2023.
//

import Foundation

struct JoinResponse: Codable {
    let id: UUID?
    let name: String
    let creator: String
    let isPrivate: Bool
    let invitationCode: String?
    let admin: String
    let points: Int
}
