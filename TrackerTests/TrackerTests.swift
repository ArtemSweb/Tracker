//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Артем Солодовников on 21.05.2025.
//


import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerScreenSnapshotTests: XCTestCase {
    // MARK: - Setup
    private var container: Dependency!
    private var navigationController: UINavigationController!
    
    override func setUp() {
        super.setUp()
        container = Dependency()
        let trackerVC = container.makeTrackerViewController(statisticsCallback: { _ in })
        navigationController = UINavigationController(rootViewController: trackerVC)
       
        _ = navigationController.view
        
        (trackerVC as? TrackerViewController)?.viewModel.loadTrackers()
    }
    
    // MARK: - Tests
    func test_trackerScreen_lightMode() {
        assertSnapshot(
            of: navigationController,
            as: .image(on: .iPhone13ProMax(.portrait), traits: .init(userInterfaceStyle: .light))
        )
    }
    
    func test_trackerScreen_darkMode() {
        assertSnapshot(
            of: navigationController,
            as: .image(on: .iPhone13ProMax(.portrait), traits: .init(userInterfaceStyle: .dark))
        )
    }

}
