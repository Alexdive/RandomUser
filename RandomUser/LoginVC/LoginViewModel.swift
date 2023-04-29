//
//  LoginViewModel.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 19.04.2023.
//

import Combine
import UIKit

enum ActivityState {
    case running, stop
}

struct LoginViewModelInput {
    let email: AnyPublisher<String?, Never>
    let pass: AnyPublisher<String?, Never>
    let loginTap: AnyPublisher<Void, Never>
}

struct LoginViewModelOutput {
    var emailTint: UIColor
    var passwTint: UIColor
    var loginEnabled: Bool
}

protocol LoginViewModelProtocol {
    var presentationObject: LoginViewPresentationObject { get }
    var activityHandler: ((ActivityState) -> Void)? { get set }
    
    func transform(input: LoginViewModelInput) -> AnyPublisher<LoginViewModelOutput, Never>
}

final class LoginViewModel: LoginViewModelProtocol {
    private let credentialValidator: CredentialValidating
    private let authService: Authentication
    private let coordinator: Coordinator
    
    private var cancellable = Set<AnyCancellable>()
    let presentationObject = LoginViewPresentationObject()
    var activityHandler: ((ActivityState) -> Void)?
    
    init(credentialValidator: CredentialValidating,
         authService: Authentication,
         coordinator: Coordinator) {
        self.credentialValidator = credentialValidator
        self.authService = authService
        self.coordinator = coordinator
    }
    
    func transform(input: LoginViewModelInput) -> AnyPublisher<LoginViewModelOutput, Never> {
        let email = input.email
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { $0 }
            .filter { !$0.isEmpty }
        
        let password = input.pass
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { $0 }
        
        let credentials = email
            .combineLatest(password)
            .eraseToAnyPublisher()
        
        input.loginTap
            .withLatestFrom(credentials)
            .map { $1 }
            .sink {[unowned self] in
                self.authService.logInWith(credentials: .init(email: $0.0, password: $0.1))
                self.activityHandler?(.running)
            }
            .store(in: &cancellable)
        
        let isValidEmail = email
            .map { [unowned self] email -> Bool in
                self.credentialValidator.isValidEmail(email)
            }
        
        let isValidPassword = password
            .map { [unowned self] pass -> Bool in
                self.credentialValidator.isValidPassword(pass)
            }
        
        let output: AnyPublisher<LoginViewModelOutput, Never> = isValidEmail
            .combineLatest(isValidPassword)
            .map { isValidEmail, isValidPassword in
                return LoginViewModelOutput(emailTint: isValidEmail ? .systemGreen : .systemRed,
                                            passwTint: isValidPassword ? .systemGreen : .systemRed,
                                            loginEnabled: isValidEmail && isValidPassword)
                
            }
            .eraseToAnyPublisher()
        
        return output
    }
}
