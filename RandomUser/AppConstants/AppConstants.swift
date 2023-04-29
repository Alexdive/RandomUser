//
//  AppConstants.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 21.04.2023.
//

import UIKit

enum AppConstants {
    enum Fonts {
        static let avenirNext13 = UIFont(name: "Avenir Next", size: 13) ?? .systemFont(ofSize: 13)
        static let avenirNext18 = UIFont(name: "Avenir Next", size: 18) ?? .systemFont(ofSize: 18)
        static let avenirMedium22 = UIFont(name: "Avenir Next Medium", size: 22) ?? .systemFont(ofSize: 22)
        static let avenirNext30 = UIFont(name: "Avenir Next", size: 30) ?? .systemFont(ofSize: 30)
    }
    enum RegEx: String {
        case email = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$"
        case password = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,}$"
    }
    enum StringURL: String {
        case userAPI = "https://randomuser.me"
    }
}
