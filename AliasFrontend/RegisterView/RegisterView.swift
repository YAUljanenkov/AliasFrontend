//
//  LoginView.swift
//  AliasFrontend
//
//  Created by Ярослав Ульяненков on 21.05.2023.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel = RegisterViewModel()
    
    func loginAction() {
        viewModel.registerUser()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15.0) {
                Text("Alias")
                    .font(.system(size: 50, weight: .bold))
                Text("Регистрация")
                    .font(.system(size: 36, weight: .bold))
                TextField("E-mail", text: $viewModel.login)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Имя", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Пароль", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Войти", action: loginAction)
                    .buttonStyle(GrowingButton())
                
            }
            .padding(20.0)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Ошибка"), message: Text (viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
