//
//  AdminViewOutputProtocol.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 23.05.2023.
//

import Foundation

protocol AdminViewOutputProtocol: AnyObject {
    func changedType(with type: TypeOfPrivate)

    func checkErrorsAndPresent(name: String?, currentType: TypeOfPrivate)
}
