//
//  AdminViewInputProtocol.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 23.05.2023.
//

import Foundation

protocol AdminViewInputProtocol: AnyObject {

    func setNetworkType()

    func setLocalType()

    func showErrorAlert(message: String)

    func setErrorGroupTextField()

    func setErrorInfectionFactorTextField()

    func setErrorPeriodTextField()

    func presentVizualization()

    func setupTextFieldBorderColor()
}
