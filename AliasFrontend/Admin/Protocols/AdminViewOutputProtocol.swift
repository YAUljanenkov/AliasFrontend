//
//  AdminViewOutputProtocol.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 23.05.2023.
//

import Foundation

protocol AdminViewOutputProtocol: AnyObject {
    func changedType(with type: TypeOfSimulation)

    func checkErrorsAndPresent(withGroup group: String?, withFactor factor: String?, withPeriod period: String?, currentType: TypeOfSimulation)
}
