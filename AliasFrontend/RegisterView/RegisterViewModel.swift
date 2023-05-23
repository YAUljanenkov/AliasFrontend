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
    var login: String = ""
    var password: String = ""
    var name: String = ""
    
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
    }
    
    func registerUser() {
        dataManager.register(name: name, email: login, password: password) {[weak self] result in
            switch result {
            case .success(let value):
                // TODO: add action.
                print(value)
            case .error(let error):
                // TODO: add proper check.
                print(error)
                self?.showAlert.toggle()
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}
