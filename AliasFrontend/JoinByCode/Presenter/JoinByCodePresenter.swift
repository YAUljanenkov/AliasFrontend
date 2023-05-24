//
//  JoinByCodePresenter.swift
//  AliasFrontend
//
//  Created by Андрей Лосюков on 24.05.2023.
//

import Foundation

// В связи с реализацией бэкенда, оказалось невозможным присоединиться к комнате только по пригласительному коду без id комнаты. Но присоединяется и к приватным.

final class JoinByCodePresenter {
    weak var viewInput: JoinByCodeViewInputProtocol?
}

extension JoinByCodePresenter: JoinByCodeViewOutputProtocol {

    // Проверка на ошибки и показ следующего экрана
    func checkErrorsAndPresent(id: String?, invitationCode: String?) {
        viewInput?.setupTextFieldBorderColor()
        if id == "" {
            viewInput?.showErrorAlert(message: "Введите непустую строку в id комнаты")
            viewInput?.setErrorIdTextField()
            return
        }
        if invitationCode == "" {
            viewInput?.showErrorAlert(message: "Введите непустую строку в пригласительном коде")
            viewInput?.setErrorInvitationCodeTextField()
            return
        }
        viewInput?.setupTextFieldBorderColor()
        viewInput?.presentRoom()
    }
}
