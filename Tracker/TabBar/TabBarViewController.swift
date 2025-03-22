//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Артем Солодовников on 22.03.2025.
//
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTabs()
        customizeTabBar()
        addTopBorder(to: tabBar, color: .tGray, thickness: 1.0)
    }
    
    private func setupTabs() {

        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tab_item_tracker"),
            tag: 0
        )
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tab_item_statistic"),
            tag: 1)
        
        viewControllers = [trackerViewController, statisticViewController]
    }
    
    private func customizeTabBar() {

        tabBar.barTintColor = .white
        tabBar.tintColor = .tBlue
        tabBar.unselectedItemTintColor = .tGray

        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)],
            for: .normal
        )
    }
    
    private func addTopBorder(to view: UIView, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: thickness)
        view.layer.addSublayer(border)
    }
}
