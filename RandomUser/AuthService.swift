//
//  AuthService.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 21.04.2023.
//

import Combine

protocol Authentication {
    var isLoggedIn: AnyPublisher<Bool, Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }
    
    func logInWith(credentials: Credentials)
    func getUserDetails() -> UserDetails?
    func logOut()
}

final class AuthService: Authentication {
    var isLoggedIn: AnyPublisher<Bool, Never> { _isLoggedIn.eraseToAnyPublisher() }
    var errorPublisher = PassthroughSubject<Error, Never>()
    
    private let dataBase: Persistence
    private let networkService: NetworkService
    private var _isLoggedIn = CurrentValueSubject<Bool, Never>(false)
    private var user: User? {
        didSet {
            _isLoggedIn.send(user != nil)
        }
    }
  
    init(dataBase: Persistence, networkService: NetworkService) {
        self.dataBase = dataBase
        self.networkService = networkService
        defer {
            do {
                user = try self.dataBase.getObject(for: .authStatus)
            } catch {
                self.errorPublisher.send(error)
            }
        }
    }
    
    func logInWith(credentials: Credentials) {
        networkService.request(UserRequest()) { [weak self] result in
            switch result {
            case .success(let user):
                do {
                    try self?.saveUser(user)
                } catch {
                    self?.errorPublisher.send(error)
                }
            case .failure(let error):
                self?.errorPublisher.send(error)
            }
        }
    }
    
    func logOut() {
        deleteUser()
    }
    
    func getUserDetails() -> UserDetails? {
        user?.results.first
    }
    
    private func saveUser(_ user: User) throws {
        try dataBase.saveObject(user, for: .authStatus)
        self.user = user
    }
    
    private func deleteUser() {
        dataBase.removeObject(for: .authStatus)
        self.user = nil
    }
}

extension PersistenceKey {
    static let authStatus = Self.init(key: "auth_status")
}


struct UserRequest: DataRequest {
    typealias Response = User
    
    var url: String {
        let baseURL: String = AppConstants.StringURL.userAPI.rawValue
        let path: String = "/api"
        return baseURL + path
    }
    
    var method: HTTPMethod { .get }
}
