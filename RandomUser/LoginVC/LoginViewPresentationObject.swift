//
//  LoginViewPresentationObject.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 21.04.2023.
//

import UIKit

struct LoginViewPresentationObject {
    let emailTF = TextFieldConfig(placeholder: "yourmail@gmail.com",
                                  imageName: "envelope",
                                  backgroundColor: .systemGray6,
                                  tintColor: .systemGray2)
    
    let passwordTF = TextFieldConfig(placeholder: "Password",
                                     imageName: "key",
                                     backgroundColor: .systemGray6,
                                     tintColor: .systemGray2)
    
    let loginWhite = TextConfig(text: "Login",
                                textColor: .white,
                                font: AppConstants.Fonts.avenirNext18)
    
    let loginLabel = TextConfig(text: "App Login",
                                textColor: .systemIndigo,
                                font: AppConstants.Fonts.avenirNext30)
    
    let backgroundColor: UIColor = .systemBackground
    let cornerRadius: CGFloat = 22
}
