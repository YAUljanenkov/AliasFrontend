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
        dataManager.login(email: login, password: password) {[weak self] result in
            switch result {
            case .success(let value):
                // TODO: add action.
                print(value)
//                navigationController?.setViewControllers([ViewController()], animated: true)
            case .error(let error):
                // TODO: add proper check.
                print(error)
                self?.showAlert.toggle()
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
