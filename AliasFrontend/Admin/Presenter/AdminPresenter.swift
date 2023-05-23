//
//  AdminPresenter.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 23.05.2023.
//

import Foundation

enum TypeOfSimulation {
    case network
    case local
}

final class AdminPresenter {
    weak var viewInput: AdminViewInputProtocol?
}

extension AdminPresenter: AdminViewOutputProtocol {

    func checkErrorsAndPresent(withGroup group: String?, withFactor factor: String?, withPeriod period: String?, currentType: TypeOfSimulation) {

        viewInput?.setupTextFieldBorderColor()
        guard let groupSize = Int(group ?? "") else {
            viewInput?.showErrorAlert(message: "Введите размер группы целым числом")
            viewInput?.setErrorGroupTextField()
            return
        }
        if groupSize < 1 {
            viewInput?.showErrorAlert(message: "Введите размер группы положительным числом")
            viewInput?.setErrorGroupTextField()
            return
        }
        if groupSize > 200 && currentType == .network {
            viewInput?.showErrorAlert(message: "API не позволяет загрузить более 200, попробуйте локально")
            viewInput?.setErrorGroupTextField()
            return
        }
        if groupSize > 1000 && currentType == .local {
            viewInput?.showErrorAlert(message: "Оперативка не всесильна... В локальном режиме до 1000 (в минимальном зуме и одновременно на других максимальных настройках начинает лагать)")
            viewInput?.setErrorGroupTextField()
            return
        }
        guard let infectionFactor = Int(factor ?? "") else {
            viewInput?.showErrorAlert(message: "Введите фактор инфекции целым числом")
            viewInput?.setErrorInfectionFactorTextField()
            return
        }
        if infectionFactor < 1 {
            viewInput?.showErrorAlert(message: "Введите фактор инфекции положительным числом")
            viewInput?.setErrorInfectionFactorTextField()
            return
        }
        if infectionFactor > 4 {
            viewInput?.showErrorAlert(message: "У зараженного не может быть более 4 соседей")
            viewInput?.setErrorInfectionFactorTextField()
            return
        }
        guard let period = Double(period ?? "") else {
            viewInput?.showErrorAlert(message: "Введите период дробным числом (через точку)")
            viewInput?.setErrorPeriodTextField()
            return
        }
        if period <= 0 {
            viewInput?.showErrorAlert(message: "Введите период положительным дробным числом")
            viewInput?.setErrorPeriodTextField()
            return
        }
        if period < 0.1 {
            viewInput?.showErrorAlert(message: "Оперативка не всесильна... Необходимо от 0.1")
            viewInput?.setErrorPeriodTextField()
            return
        }
        viewInput?.setupTextFieldBorderColor()
        viewInput?.presentVizualization()
    }


    func changedType(with type: TypeOfSimulation) {
        switch (type) {
        case .local:
            viewInput?.setLocalType()
        case .network:
            viewInput?.setNetworkType()
        }
    }
}
