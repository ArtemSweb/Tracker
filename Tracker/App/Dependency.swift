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
        let grouped = trackerStore.fetchTrackersGroupedByCategory()
        let trackers = grouped.flatMap { $0.trackers }
        let records = trackerRecordStore.fetchAllRecords()
        return StatisticViewModel(trackers: trackers, records: records)
    }
    
    func makeTrackerViewController(statisticsCallback: @escaping (StatisticViewModel) -> Void) -> UIViewController {
        let viewModel = makeTrackerViewModel()
        viewModel.onStatisticUpdate = statisticsCallback
        let categoryViewModel = TrackerCategoryViewModel(categoryStore: trackerCategoryStore)
        
        return TrackerViewController(viewModel: viewModel, categoryViewModel: categoryViewModel)
    }
    
    // MARK: - TabBarController
    func makeTabBarController() -> UITabBarController {
        
        let statVM = makeStatisticViewModel()
        let statsVC = StatisticViewController(viewModel: statVM)
        let trackerVC = makeTrackerViewController{ updatedStat in
            statsVC.update(with: updatedStat)
        }
        
        let trackerNav = UINavigationController(rootViewController: trackerVC)
        trackerNav.tabBarItem = UITabBarItem(title: L10n.trackers, image: UIImage(resource: .tabItemTracker), tag: 0)

        let statsNav = UINavigationController(rootViewController: statsVC)
        statsNav.tabBarItem = UITabBarItem(title: L10n.statistic, image: UIImage(resource: .tabItemStatistic), tag: 1)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackerNav, statsNav]
        
        addTopLine(to: tabBarController.tabBar)
        
        return tabBarController
    }
    
    //MARK: - Приватные методы
    private func addTopLine(to tabBar: UITabBar) {
        let topLine = UIView()
        topLine.backgroundColor = .tGray
        topLine.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(topLine)

        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: tabBar.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

}
