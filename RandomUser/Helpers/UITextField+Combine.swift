//
//  UITextField+Combine.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 21.04.2023.
//

import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(
                for: UITextField.textDidChangeNotification,
                object: self)
            .map(\.object)
            .map { $0 as! UITextField }
            .map(\.text)
            .prepend("")
            .eraseToAnyPublisher()
    }
}
