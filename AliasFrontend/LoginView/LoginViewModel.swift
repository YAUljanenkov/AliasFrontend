//
//  LoginViewModel.swift
//  AliasFrontend
//
//  Created by Ярослав Ульяненков on 21.05.2023.
//

import Foundation
import Alamofire

class LoginViewModel: ObservableObject {
    weak var navigationController: UINavigationController?
    var dataManager: ServiceProtocol
    var login: String = ""
    var password: String = ""
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    init( dataManager: ServiceProtocol = Service.shared, navigationController: UINavigationController?) {
        self.dataManager = dataManager
        self.navigationController = navigationController
    }
    
    func loginUser() {
        // Вход не работает только один раз (ошибка на бэкенде), поэтому входим только после регистрации.
        dataManager.login(email: login, password: password) {[weak self] result in
            switch result {
            case .success(let value):
                print(value)
//                navigationController?.setViewControllers([ViewController()], animated: true)
            case .error(let error):
                print(error)
                self?.showAlert.toggle()
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
