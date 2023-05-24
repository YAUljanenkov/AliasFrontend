//
//  LoginViewModel.swift
//  AliasFrontend
//
//  Created by Ярослав Ульяненков on 21.05.2023.
//

import Foundation
import Alamofire

class RegisterViewModel: ObservableObject {
    var dataManager: ServiceProtocol
    weak var navigationController: UINavigationController?
    var login: String = ""
    var password: String = ""
    var name: String = ""
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    init(dataManager: ServiceProtocol = Service.shared, navigationController: UINavigationController?) {
        self.dataManager = dataManager
        self.navigationController = navigationController
    }
    
    func registerUser() {
        // Регистрация пользователя с помощью Alamofire.
        dataManager.register(name: name, email: login, password: password) { [weak self] result in
            switch result {
            case .success(let value):
                print(value)
                guard let login = self?.login, let password = self?.password else {
                    self?.showAlert.toggle()
                    self?.errorMessage = "Неизвестная ошибка"
                    return
                }
                
                // Registration does not log in, we need to do it afterwards to get bearer token.
                self?.dataManager.login(email: login, password: password) { result in
                    switch result {
                    // Вход, если регистрация прошла успешно.
                    case .success(let value):
                        let presenter = AdminPresenter()
                        let viewController = AdminViewController(output: presenter)
                        presenter.viewInput = viewController
                        print(value)
                        self?.navigationController?.setViewControllers([viewController], animated: true)
//                        let presenter = JoinByCodePresenter()
//                        let viewController = JoinByCodeViewController(output: presenter)
//                        presenter.viewInput = viewController
//                        print(value)
//                        self?.navigationController?.setViewControllers([viewController], animated: true)
                    case .error(let error):
                        print(error)
                        self?.showAlert.toggle()
                        self?.errorMessage = error.localizedDescription
                    }
                }
            case .error(let error):
                print(error)
                self?.showAlert.toggle()
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
