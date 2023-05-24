//
//  Service.swift
//  AliasFrontend
//
//  Created by Ярослав Ульяненков on 21.05.2023.
//

import Foundation
import Alamofire

enum RequestResult {
    case success(value: Codable)
    case error(error: Error)
}

// Проток для общения с сервисом
protocol ServiceProtocol {
    func register(name: String, email: String, password: String, complition: @escaping (RequestResult) -> Void)
    func login(email: String, password: String, complition: @escaping (RequestResult) -> Void)
    func createRoom(name: String, isPrivate: Bool, complition: @escaping (RequestResult) -> Void)
    func joinByInvitationCode(gameRoomId: String, invitationCode: String, complition: @escaping (RequestResult) -> Void)
}

class Service: ServiceProtocol {
    static let ip = "127.0.0.1"
    static let port = 8080
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service {

    // Регистрация
    func register(name: String, email: String, password: String, complition: @escaping (RequestResult) -> Void) {
        let url = URL(string: "http://\(Service.ip):\(Service.port)/users/register")!
        // Параметры запроса
        let parameters = ["name": name, "email": email, "password": password]
        // Запрос "POST"
        AF.upload(multipartFormData: { data in
            for (key, value) in parameters {
                 data.append(Data(value.utf8), withName: key)
             }
        }, to: url, method: .post)
        .validate()
        .responseDecodable(of: UserResponse.self) { response in
            // Обработка результата
            switch response.result {
            case .success(let value):
                complition(.success(value: value))
            case .failure(let error):
                complition(.error(error: error))
            }
        }
    }

    // Вход в аккаунт
    func login(email: String, password: String, complition: @escaping (RequestResult) -> Void) {
        let url = URL(string: "http://\(Service.ip):\(Service.port)/users/login")!
        // Параметры запроса
        let parameters = ["email": email, "password": password]
        // Запрос "POST"
        AF.upload(multipartFormData: { data in
            for (key, value) in parameters {
                 data.append(Data(value.utf8), withName: key)
             }
        }, to: url, method: .post)
        .validate()
        .responseDecodable(of: LoginResponse.self) { response in
            // Обработка результата
            switch response.result {
            case .success(let value):
                let keyChainService = KeyChainService()
                do {
                    try keyChainService.upsertToken(Data(value.value.utf8), identifier: "bearer")
                    complition(.success(value: value))
                } catch {
                    complition(.error(error: error))
                }
            case .failure(let error):
                complition(.error(error: error))
            }
        }
    }

    // Создание комнаты
    func createRoom(name: String, isPrivate: Bool, complition: @escaping (RequestResult) -> Void) {
        let keyChainService = KeyChainService()
        var token = ""
        do {
            token = try keyChainService.getToken(identifier: "bearer")
        } catch {}
        let url = URL(string: "http://\(Service.ip):\(Service.port)/game-rooms/create")!
        // Параметры запроса
        let parameters = ["name": name, "isPrivate": String(isPrivate)]
        // Хедер запроса с авторизационным токеном
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        // Запрос "POST"
        AF.upload(multipartFormData: { data in
            for (key, value) in parameters {
                 data.append(Data(value.utf8), withName: key)
             }
        }, to: url, method: .post, headers: headers)
        .validate()
        .responseDecodable(of: CreateRoomResponse.self) { response in
            print(response)
            // Обработка результата
            switch response.result {
            case .success(let value):
                complition(.success(value: value))
            case .failure(let error):
                complition(.error(error: error))
            }
        }
    }

    // Вход по пригласительному коду
    func joinByInvitationCode(gameRoomId: String, invitationCode: String, complition: @escaping (RequestResult) -> Void) {
        let keyChainService = KeyChainService()
        var token = ""
        do {
            token = try keyChainService.getToken(identifier: "bearer")
        } catch {}
        let url = URL(string: "http://\(Service.ip):\(Service.port)/game-rooms/join-room")!
        // Параметры запроса
        let parameters = ["gameRoomId": gameRoomId, "invitationCode": invitationCode]
        // Заголовок запроса
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        AF.upload(multipartFormData: { data in
            for (key, value) in parameters {
                 data.append(Data(value.utf8), withName: key)
             }
        }, to: url, method: .post, headers: headers)
        .validate()
        .responseDecodable(of: JoinResponse.self) { response in
            print(response)
            // Обработка результата
            switch response.result {
            case .success(let value):
                complition(.success(value: value))
            case .failure(let error):
                complition(.error(error: error))
            }
        }
    }

    // Выход из аккаунта
    func logout(complition: @escaping (RequestResult) -> Void) {
        let url = URL(string: "http://\(Service.ip):\(Service.port)/users/logout")!
        let keyChainService = KeyChainService()
        do {
            let token = try keyChainService.getToken(identifier: "bearer")
            // Заголовок запроса
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let value):
                    complition(.success(value: value))
                case .failure(let error):
                    complition(.error(error: error))
                }
            }
        } catch {
            complition(.error(error: error))
        }
    }
}
