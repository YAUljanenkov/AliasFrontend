//
//  JoinByCodeViewInput.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 24.05.2023.
//

import Foundation

protocol JoinByCodeViewInputProtocol: AnyObject {

    func showErrorAlert(message: String)

    func setErrorIdTextField()
    
    func setErrorInvitationCodeTextField()

    func presentRoom()

    func setupTextFieldBorderColor()
}
