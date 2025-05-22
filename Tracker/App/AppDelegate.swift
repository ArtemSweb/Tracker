//
//  AppDelegate.swift
//  Tracker
//
//  Created by Артем Солодовников on 21.03.2025.
//

import UIKit
import YandexMobileMetrica

private enum Constants {
    static let metricaAPIKey = "e4017a71-ba9b-44be-99b7-d5fa34d1265a"
}

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: Constants.metricaAPIKey) else { // используйте ваш ключ
                return true
            }
                
        YMMYandexMetrica.activate(with: configuration)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

