//
//  File.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 21.04.2023.
//

import UIKit
import Combine

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    private let router: Routing
    private let dataBase: Persistence
    private let authService: Authentication
    private let credentialValidator: CredentialValidating
    private let networkService: NetworkService
    
    private var cancellable = Set<AnyCancellable>()
    
    init(router: Routing,
         dataBase: Persistence,
         authService: Authentication,
         credentialValidator: CredentialValidating,
         networkService: NetworkService) {
        self.router = router
        self.dataBase = dataBase
        self.authService = authService
        self.credentialValidator = credentialValidator
        self.networkService = networkService
    }
    
    func start() {
        authService.isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] isLoggedIn in
                if isLoggedIn {
                    let userCoordinator = UserVCCoordinator(
                        router: router,
                        authService: authService)
                    userCoordinator.start()
                } else {
                    let loginCoordinator = LoginVCCoordinator(
                        router: router,
                        authService: authService,
                        credentialValidator: credentialValidator)
                    loginCoordinator.start()
                }
            }
            .store(in: &cancellable)
    }
}
