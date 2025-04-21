//
//  Dependency.swift
//  Tracker
//
//  Created by Артем Солодовников on 12.04.2025.
//

import UIKit

final class Dependency {
    
    
    // MARK: - TabBarController
    func makeTabBarController() -> UITabBarController {
        let trackerVC = TrackerViewController()
        let trackerNav = UINavigationController(rootViewController: trackerVC)
        trackerNav.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "tab_item_tracker"), tag: 0)

        let statsVC = StatisticViewController()
        let statsNav = UINavigationController(rootViewController: statsVC)
        statsNav.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "tab_item_statistic"), tag: 1)

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
