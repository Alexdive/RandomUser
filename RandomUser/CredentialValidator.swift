//
//  CredentialValidator.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 21.04.2023.
//

import Foundation

struct ValidatorConfiguration {
    let emailRegEx: String
    let passwordRegEx: String
}

protocol CredentialValidating {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ pass: String) -> Bool
}

final class CredentialValidator: CredentialValidating {
    let emailRegEx: String
    let passwordRegEx: String
    
    init(with config: ValidatorConfiguration) {
        self.emailRegEx = config.emailRegEx
        self.passwordRegEx = config.passwordRegEx
    }
        
    
    func isValidEmail(_ email: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func isValidPassword(_ pass: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pass.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
