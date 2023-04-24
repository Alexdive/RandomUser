//
//  UIButton+BackgroundColor.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 21.04.2023.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor?, forState: UIControl.State) {
        guard let color = color else { return }
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
