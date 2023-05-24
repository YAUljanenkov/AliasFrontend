//
//  CreateRoomResponse.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 24.05.2023.
//

import Foundation

struct CreateRoomResponse: Codable {
    let id: UUID?
    let name: String
    let invitationCode: String
    let isPrivate: Bool
    let creator: UserResponse
    let admin: UserResponse
    let pointsPerWord: Int
}
