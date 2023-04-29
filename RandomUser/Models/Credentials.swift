//
//  Credentials.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 22.04.2023.
//

import Foundation

struct Credentials {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        self.password = password.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
