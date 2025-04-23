//
//  Dependency.swift
//  Tracker
//
//  Created by Артем Солодовников on 12.04.2025.
//

import UIKit

final class Dependency {
    
    // MARK: - Инъекции
    func makeTrackerViewModel() -> TrackerViewModel {
        TrackerViewModel()
    }
    
    func makeStatisticViewModel() -> StatisticViewModel {
        StatisticViewModel()
    }
    
    func makeTrackerViewController() -> UIViewController {
        let viewModel = makeTrackerViewModel()
        return TrackerViewController(viewModel: viewModel)
    }
    
    func makeStatisticViewController() -> UIViewController {
        let viewModel = makeStatisticViewModel()
        return StatisticViewController(viewModel: viewModel)
    }
    
    // MARK: - TabBarController
    func makeTabBarController() -> UITabBarController {
        let trackerVC = makeTrackerViewController()
        let trackerNav = UINavigationController(rootViewController: trackerVC)
        trackerNav.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(resource: .tabItemTracker), tag: 0)
        
        let statsVC = makeStatisticViewController()
        let statsNav = UINavigationController(rootViewController: statsVC)
        statsNav.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(resource: .tabItemStatistic), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackerNav, statsNav]
        
        let topLine = UIView()
        topLine.backgroundColor = UIColor.tGray
        topLine.translatesAutoresizingMaskIntoConstraints = false
        tabBarController.tabBar.addSubview(topLine)
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: tabBarController.tabBar.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: tabBarController.tabBar.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: tabBarController.tabBar.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        return tabBarController
    }
}
