//
//  LoginView.swift
//  AliasFrontend
//
//  Created by Ярослав Ульяненков on 21.05.2023.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    
    func loginAction() {
        viewModel.loginUser()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15.0) {
                Text("Alias")
                    .font(.system(size: 50, weight: .bold))
                Text("Вход")
                    .font(.system(size: 36, weight: .bold))
                TextField("E-mail", text: $viewModel.login)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Пароль", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Войти", action: loginAction)
                    .buttonStyle(GrowingButton())
                HStack(spacing: 10.0) {
                    Text("Нет аккаунта?")
                        .font(.system(size: 14.0))
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Label("Зарегистрироваться", systemImage: "person.fill.badge.plus")
                            .font(.system(size: 14.0))
                    }
                }
                
            }
            .padding(20.0)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Ошибка"), message: Text (viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
        
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue.cornerRadius(10.0))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
