//
//  AdminPresenter.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 23.05.2023.
//

import Foundation

enum TypeOfPrivate {
    case privateGame
    case publicGame
}

final class AdminPresenter {
    weak var viewInput: AdminViewInputProtocol?
}

extension AdminPresenter: AdminViewOutputProtocol {

    func checkErrorsAndPresent(name: String?, currentType: TypeOfPrivate) {

        viewInput?.setupTextFieldBorderColor()
        if name == nil {
            viewInput?.showErrorAlert(message: "Введите непустую строку")
            viewInput?.setErrorGroupTextField()
            return
        }
        if name == "" {
            viewInput?.showErrorAlert(message: "Введите непустую строку")
            viewInput?.setErrorGroupTextField()
        }
        viewInput?.setupTextFieldBorderColor()
        viewInput?.presentRoom()
    }


    func changedType(with type: TypeOfPrivate) {
        switch (type) {
        case .privateGame:
            viewInput?.setPrivateType()
        case .publicGame:
            viewInput?.setPublicType()
        }
    }
}
