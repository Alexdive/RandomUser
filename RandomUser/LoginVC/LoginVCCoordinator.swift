//
//  LoginVCCoordinator.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 22.04.2023.
//

import UIKit

final class LoginVCCoordinator: Coordinator {
    private let router: Routing
    private let authService: Authentication
    private let credentialValidator: CredentialValidating
    
    init(router: Routing,
         authService: Authentication,
         credentialValidator: CredentialValidating) {
        self.router = router
        self.authService = authService
        self.credentialValidator = credentialValidator
    }
    
    func start() {
        let viewModel: LoginViewModelProtocol = LoginViewModel(
            credentialValidator: credentialValidator,
            authService: authService,
            coordinator: self)
        
        let vc = LoginViewController(viewModel: viewModel)
        router.setRootController(vc)
    }
}
