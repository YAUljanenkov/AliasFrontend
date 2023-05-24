//
//  JoinByCodeViewOutput.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 24.05.2023.
//

import Foundation

protocol JoinByCodeViewOutputProtocol: AnyObject {

    func checkErrorsAndPresent(id: String?, invitationCode: String?)
}
