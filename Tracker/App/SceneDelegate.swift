//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.03.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let tabBarController = Dependency().makeTabBarController()
        
        let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        onboardingVC.onFinished = {
            self.window?.rootViewController = tabBarController
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = onboardingVC
        window?.makeKeyAndVisible()
    }
}

