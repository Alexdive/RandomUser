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
    
    func getProfileImage() -> Future<ImageProtocol?, Never>
    func logOut()
}

final class UserViewModel: UserViewModelProtocol {
    var logoutPublisher = PassthroughSubject<Void, Never>()
    let userDetails: UserDetails
    let imageDownloader: ImageDownloader
    
    private let coordinator: Coordinator
    
    init(userDetails: UserDetails,
         coordinator: Coordinator,
         imageDownloader: ImageDownloader = KingFisherImageDownloader()) {
        self.userDetails = userDetails
        self.coordinator = coordinator
        self.imageDownloader = imageDownloader
    }
   
    func getProfileImage() -> Future<ImageProtocol?, Never> {
        return Future { [weak self] promise in
            guard let self else { return }
            self.imageDownloader.retrieveImage(stringUrl: self.userDetails.picture.large) { image in
                promise(.success(image))
            }
        }
    }
    
    func logOut() {
        logoutPublisher.send()
    }
}
