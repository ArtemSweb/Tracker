//
//  Dependency.swift
//  Tracker
//
//  Created by Артем Солодовников on 12.04.2025.
//

import UIKit
import CoreData

final class Dependency {
    
    //MARK: - CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        DaysValueTransformer.register()
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var trackerStore = TrackerStore(context: context)
    lazy var trackerCategoryStore = TrackerCategoryStore(context: context)
    lazy var trackerRecordStore = TrackerRecordStore(context: context)
    
    // MARK: - Инъекции
    func makeTrackerViewModel() -> TrackerViewModel {
        TrackerViewModel(
            trackerStore: trackerStore,
            categoryStore: trackerCategoryStore,
            recordStore: trackerRecordStore
        )
    }
    
    func makeStatisticViewModel() -> StatisticViewModel {
        StatisticViewModel()
    }
    
    func makeTrackerViewController() -> UIViewController {
        let viewModel = makeTrackerViewModel()
        let categoryViewModel = TrackerCategoryViewModel(categoryStore: trackerCategoryStore)
        return TrackerViewController(viewModel: viewModel, categoryViewModel: categoryViewModel)
    }
    
    func makeStatisticViewController() -> UIViewController {
        let viewModel = makeStatisticViewModel()
        return StatisticViewController(viewModel: viewModel)
    }
    
    // MARK: - TabBarController
    func makeTabBarController() -> UITabBarController {
        let trackerVC = makeTrackerViewController()
        let trackerNav = UINavigationController(rootViewController: trackerVC)
        trackerNav.tabBarItem = UITabBarItem(title: L10n.trackers, image: UIImage(resource: .tabItemTracker), tag: 0)
        
        let statsVC = makeStatisticViewController()
        let statsNav = UINavigationController(rootViewController: statsVC)
        statsNav.tabBarItem = UITabBarItem(title: L10n.statistic, image: UIImage(resource: .tabItemStatistic), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackerNav, statsNav]
        
        let topLine = UIView()
        topLine.backgroundColor = .tGray
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
