//
//  UITextField+Image.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 21.04.2023.
//

import UIKit

extension UITextField {
    func setIcon(_ image: UIImage?) {
        guard let image = image else { return }
        let iconView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        iconView.image = image
        iconView.contentMode = .scaleAspectFit
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 40, height: 20))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

extension UITextField {
    func enablePasswordHideToggle() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 6)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
    }
    
    @objc private func togglePasswordView(_ sender: Any) {
        isSecureTextEntry.toggle()
        (rightView as? UIButton)?.isSelected.toggle()
    }
}
