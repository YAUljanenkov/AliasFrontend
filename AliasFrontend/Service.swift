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

protocol ServiceProtocol {
    func register(name: String, email: String, password: String, complition: @escaping (RequestResult) -> Void)
    func login(email: String, password: String, complition: @escaping (RequestResult) -> Void)
    func listAll(complition: @escaping ([RoomResponse]) -> Void)
    func joinRoom(gameRoomId: UUID, complition: @escaping (RequestResult) -> Void)
    func leaveGameRoom(gameRoomId: UUID, complition: @escaping (RequestResult) -> Void)
    func logout(complition: @escaping (RequestResult) -> Void)
}

class Service: ServiceProtocol {
    static let ip = "alias-swift-api.onrender.com"
    static let port = 8080
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service {
    func register(name: String, email: String, password: String, complition: @escaping (RequestResult) -> Void) {
        let url = URL(string: "https://\(Service.ip)/users/register")!
        let parameters = ["name": name, "email": email, "password": password]
        AF.upload(multipartFormData: { data in
            for (key, value) in parameters {
                 data.append(Data(value.utf8), withName: key)
             }
        }, to: url, method: .post)
        .validate()
        .responseDecodable(of: UserResponse.self) { response in
            switch response.result {
            case .success(let value):
                complition(.success(value: value))
            case .failure(let error):
                complition(.error(error: error))
            }
        }
    }

    func login(email: String, password: String, complition: @escaping (RequestResult) -> Void) {
        let url = URL(string: "https://\(Service.ip)/users/login")!
        let parameters = ["email": email, "password": password]
        AF.upload(multipartFormData: { data in
            for (key, value) in parameters {
                 data.append(Data(value.utf8), withName: key)
             }
        }, to: url, method: .post)
        .validate()
        .responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let value):
                let keyChainService = KeyChainService()
                do {
                    // Save authorization token
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

    /// List all available public rooms
    func listAll(complition: @escaping ([RoomResponse]) -> Void) {
        let url = URL(string: "https://\(Service.ip)/game-rooms/list-all")!
        let keyChainService = KeyChainService()
        do {
            let token = try keyChainService.getToken(identifier: "bearer")
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [RoomResponse].self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    complition(value)
                case .failure(let error):
                    print(error)
                    complition([])
                }
            }
        } catch {
            complition([])
        }
    }

    func joinRoom(gameRoomId: UUID, complition: @escaping (RequestResult) -> Void) {
        let url = URL(string: "https://\(Service.ip)/game-rooms/join-room")!
        let keyChainService = KeyChainService()
        do {
            let token = try keyChainService.getToken(identifier: "bearer")
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            let parameters = ["gameRoomId": gameRoomId]
            AF.upload(multipartFormData: { data in
                for (key, value) in parameters {
                    data.append(Data(value.uuidString.utf8), withName: key)
                 }
            }, to: url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: JoinRoomResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    complition(.success(value: value))
                case .failure(let error):
                    print(error)
                    complition(.error(error: error))
                }
            }
        } catch {
            complition(.error(error: error))
        }
    }

    func leaveGameRoom(gameRoomId: UUID, complition: @escaping (RequestResult) -> Void) {
        let url = URL(string: "https://\(Service.ip)/game-rooms/leave-room")!
        let keyChainService = KeyChainService()
        do {
            let token = try keyChainService.getToken(identifier: "bearer")
            let headers: HTTPHeaders = [.authorization(bearerToken: token)]
            let parameters = ["gameRoomId": gameRoomId]
            AF.upload(multipartFormData: { data in
                for (key, value) in parameters {
                    data.append(Data(value.uuidString.utf8), withName: key)
                 }
            }, to: url, method: .post, headers: headers)
            .validate()
            .response { response in
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
    
    func logout(complition: @escaping (RequestResult) -> Void) {
        let url = URL(string: "https://\(Service.ip)/users/logout")!
        let keyChainService = KeyChainService()
        do {
            let token = try keyChainService.getToken(identifier: "bearer")
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
