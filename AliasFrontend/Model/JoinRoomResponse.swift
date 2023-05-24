//
//  JoinRoomResponse.swift
//  AliasFrontend
//
//  Created by Мельник Всеволод on 24.05.2023.
//

import Foundation

struct JoinRoomResponse: Codable {
    let id: UUID
    let name: String
    let isPrivate: Bool
    let creator: String
    let admin: String
    let invitationCode: String
    let points: Int
}
