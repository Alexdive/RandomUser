//
//  SceneDelegate.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 19.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootController = makeRootController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        
        appCoordinator = makeAppCoordinator(with: rootController)
        appCoordinator?.start()
    }
    
    func makeRootController() -> UINavigationController {
        let controller = UINavigationController()
        controller.view.backgroundColor = .white
        controller.isNavigationBarHidden = true
        return controller
    }
    
    func makeAppCoordinator(with rootController: UINavigationController) -> AppCoordinator {
        let router: Routing = Router(rootViewController: rootController)
        let dataBase: Persistence = UserDefaultsPersister(userDefaults: .standard)
        let networkService: NetworkService = DefaultNetworkService()
        let authService: Authentication = AuthService(dataBase: dataBase,
                                                      networkService: networkService)
        
        let config = ValidatorConfiguration(
            emailRegEx: AppConstants.RegEx.email.rawValue,
            passwordRegEx: AppConstants.RegEx.password.rawValue)
        let credentialValidator: CredentialValidating = CredentialValidator(with: config)
        
        return AppCoordinator(router: router,
                              dataBase: dataBase,
                              authService: authService,
                              credentialValidator: credentialValidator,
                              networkService: networkService)
    }
}
