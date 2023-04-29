//
//  UserVCCoordinator.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 22.04.2023.
//

import Combine
import UIKit

final class UserVCCoordinator: Coordinator {
    private var subscriptions = Set<AnyCancellable>()
    private let router: Routing
    private let authService: Authentication
    
    init(router: Routing,
         authService: Authentication) {
        self.router = router
        self.authService = authService
    }
    
    func start() {
        guard let userDetails = authService.getUserDetails() else { return }
        let viewModel: UserViewModelProtocol = UserViewModel(userDetails: userDetails,
                                                     coordinator: self)
        viewModel.logoutPublisher
            .sink { [weak self] _ in
                self?.authService.logOut()
            }
            .store(in: &subscriptions)
        
        let vc = UserViewController(viewModel: viewModel)
        router.setRootController(vc)
    }
}
