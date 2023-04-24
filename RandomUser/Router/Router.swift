//
//  Router.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 21.04.2023.
//

import UIKit

protocol Routing {
    func push(_ viewController: UIViewController)
    func pop(animated: Bool)
    func setRootController(_ viewController: UIViewController)
}

final class Router: Routing {
    private let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func push(_ viewController: UIViewController) {
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func pop(animated: Bool) {
        rootViewController.popViewController(animated: animated)
    }
    
    func setRootController(_ viewController: UIViewController) {
        UIView.transition(with: rootViewController.view,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.rootViewController.setViewControllers([viewController], animated: false)
        })
    }
}
