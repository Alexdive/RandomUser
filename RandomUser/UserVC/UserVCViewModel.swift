//
//  UserVCViewModel.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 22.04.2023.
//

import Combine

protocol UserViewModelProtocol {
    var logoutPublisher: PassthroughSubject<Void, Never> { get }
    var userDetails: UserDetails { get }
    
    func logOut()
}

final class UserViewModel: UserViewModelProtocol {
    var logoutPublisher = PassthroughSubject<Void, Never>()
    let userDetails: UserDetails
    
    private let coordinator: Coordinator
    
    init(userDetails: UserDetails,
         coordinator: Coordinator) {
        self.userDetails = userDetails
        self.coordinator = coordinator
    }
    
    func logOut() {
        logoutPublisher.send()
    }
}
