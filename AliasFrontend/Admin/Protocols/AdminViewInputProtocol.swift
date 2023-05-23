//
//  AdminViewInputProtocol.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 23.05.2023.
//

import Foundation

protocol AdminViewInputProtocol: AnyObject {

    func setPublicType()

    func setPrivateType()

    func showErrorAlert(message: String)

    func setErrorGroupTextField()

    func presentRoom()

    func setupTextFieldBorderColor()
}
